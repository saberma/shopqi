#encoding: utf-8
require 'spec_helper'

describe Admin::PaymentsController do

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:payment_alipay) do # 支付方式:支付宝
    Factory :payment_alipay, shop: shop
  end

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#update' do

    it "should be success" do
      attrs = payment_alipay.attributes.clone
      service = ActiveMerchant::Billing::Integrations::Alipay::Helper::TRADE_CREATE_BY_BUYER # 改为担保交易
      attrs.merge! key: 'abcdef', account: '123456', email: 'admin@shopqi.com', service: service
      post :update, id: payment_alipay.id, payment: attrs
      payment_alipay.reload
      payment_alipay.service.should eql service
      payment_alipay.key.should eql 'abcdef'
      payment_alipay.account.should eql '123456'
      payment_alipay.email.should eql 'admin@shopqi.com'
    end

    it "should support empty key" do # 更新时不输入key
      attrs = payment_alipay.attributes.clone
      attrs.merge! key: nil, account: 'admin@shopqi.com'
      post :update, id: payment_alipay.id, payment: attrs
      payment_alipay.reload
      payment_alipay.account.should eql 'admin@shopqi.com'
      payment_alipay.key.should_not be_blank
    end

  end

end
