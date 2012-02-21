require 'spec_helper'

describe Admin::AccountController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#change_ownership' do

    let(:normal_user) { Factory :normal_user, shop: shop }

    before { user }

    describe 'permissions belong to' do # 权限属于

      describe 'old admin permissions' do # 原管理员权限

        it 'should be add' do # 要重新初始化
          user.permissions.should be_empty
          post :change_ownership, user: { id: normal_user.id }
          user.reload.permissions.should_not be_empty
        end

      end

      describe 'new admin permissions' do # 新管理员权限

        it 'should be clear' do # 被清空
          normal_user.permissions.should_not be_empty
          post :change_ownership, user: { id: normal_user.id }
          normal_user.reload.permissions.should be_empty
        end

      end

    end

  end

  context 'pay plan' do # 续费

    it 'should get pay plan' do
      get :pay_plan
      response.should be_success
    end

    it 'should get confirm pay plan' do
      post :confirm_pay_plan, consumption: { quantity: 2 }
      response.should be_success
    end

  end

  context '#notify' do # 支付宝从后台发送通过

    let(:consumption) { Factory(:consumption, shop: shop) } # 支付两年

    before do
      controller.stub!(:valid?) { true } # 向支付宝校验notification的合法性
    end

    context 'trade status is TRADE_FINISHED' do # 交易完成

      let(:attrs) { { out_trade_no: consumption.token, notify_id: '123456', trade_status: 'TRADE_FINISHED', total_fee: consumption.total_price } }

      context 'shop is available' do # 未到期

        before do
          shop.deadline = Date.today.advance months: 1 # 一个月后才到期
          shop.save
        end

        it 'should change consumption status to true' do
          consumption.status.should be_false
          post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.body.should eql 'success'
          consumption.reload.status.should be_true
          shop.reload.deadline.should eql Date.today.advance(years: 2, months: 1) # 两年一个月后到期
        end

      end

      context 'shop is unavailable' do # 已过期

        before do
          shop.deadline = Date.today.advance months: -1 # 一个月前已过期
          shop.save
        end

        it 'should change consumption status to true' do
          consumption.status.should be_false
          post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.body.should eql 'success'
          consumption.reload.status.should be_true
          shop.reload.deadline.should eql Date.today.advance(years: 2) # 二年后到期
        end

      end

      it 'should be retry' do # 要支持重复请求
        consumption.status = true
        consumption.save
        expect do
          post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.body.should eql 'success'
        end.should_not change(shop, :deadline)
      end

    end

    context 'trade status is WAIT_BUYER_PAY' do # 等待顾客付款

      let(:attrs) { { out_trade_no: consumption.token, notify_id: '123456', trade_status: 'WAIT_BUYER_PAY', total_fee: consumption.total_price } }

      it 'should remain consumption status' do
        consumption.status.should be_false
        expect do
          post :notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.body.should eql 'success'
        end.should_not change(shop, :deadline)
        consumption.reload.status.should be_false
      end

    end

  end

  context '#done' do # 支付宝直接跳转回商店(支付成功后才会返回)

    let(:consumption) { Factory(:consumption, shop: shop) }

    before { consumption }

    context 'trade status is TRADE_SUCCESS' do # 交易完成

      let(:attrs) { { out_trade_no: consumption.token, trade_status: 'TRADE_SUCCESS', total_fee: consumption.total_price } }

      context 'shop is available' do # 未到期

        before do
          shop.deadline = Date.today.advance months: 1 # 一个月后才到期
          shop.save
        end

        it 'should change consumption status to true' do
          get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.should be_redirect
          consumption.reload.status.should be_true
          shop.reload.deadline.should eql Date.today.advance(years: 2, months: 1) # 兩年一个月后到期
        end

      end

      context 'shop is unavailable' do # 已过期

        before do
          shop.deadline = Date.today.advance months: -1 # 一个月前已过期
          shop.save
        end

        it 'should change consumption status to true' do
          get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.should be_redirect
          consumption.reload.status.should be_true
          shop.reload.deadline.should eql Date.today.advance(years: 2) # 二年后到期
        end

      end

      it 'should be retry' do # 要支持重复请求
        consumption.status = true
        consumption.save
        expect do
          get :done, attrs.merge(sign_type: 'md5', sign: sign(attrs, AlipayConfig['key']))
          response.should be_redirect
        end.should_not change(shop, :deadline)
      end

    end

  end

end
