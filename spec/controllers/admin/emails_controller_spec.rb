#encoding: utf-8
require 'spec_helper'

describe Admin::EmailsController do
  include Devise::TestHelpers

  let(:user){ Factory(:user)}
  let(:shop){ user.shop}
  let(:subscribes){ shop.subscribes}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#follow' do
    it "should create subscribe success" do
      expect do
        xhr :post, :follow,subscribe_type: 'email', address: "ee@gmail.com"
      end.should change(Subscribe, :count).by(1)
    end
  end

  context '#unfollow' do
    it "should remove a subscribe " do
      expect do
        xhr :delete, :unfollow, id: subscribes.first.id
      end.should change(Subscribe,:count).by(-1)
    end
  end

  context '#preview' do

    let(:iphone4) { Factory :iphone4, shop: shop }

    let(:payment_alipay) do # 支付方式:支付宝
      Factory :payment_alipay, shop: shop
    end

    before { [payment_alipay, iphone4] }

    it "should get order confirm" do # 发给顾客的订单确认
      title, body = KeyValues::Mail::Type.find_by_code('order_confirm').title_body
      get :preview, view_type: 'text', email: { title: "#{title}", body: "#{body}" }
      title = assigns[:subject]
      body = assigns[:body]
      title.should include '您在测试商店的订单下单成功'
      body.should include '尊敬的马海波'
      body.should include '您好,恭喜您已经在测试商店订购商品成功!'
      body.should include '订单号：9999'
      body.should include '收货人信息： 马海波'
      body.should include '广东省 深圳市 南山区 科技园南区6栋311'
      body.should include '1 x iphone4  单价： ¥3000.0'
      body.should include '订单总额： ¥3010.0 元  | 商品总额： ¥3000.0 元  | 发货方式及金额： 普通快递 - ¥10.0 元'
      body.should include '付款方式： 在线支付-支付宝'
      body.should include '欢迎您再次到测试商店购物，祝您购物愉快！'
      title.should_not include 'Liquid error'
      body.should_not include 'Liquid error'
    end

    it "should get new order notify" do # 发给商店管理员的订单提醒
      title, body = KeyValues::Mail::Type.find_by_code('new_order_notify').title_body
      get :preview, view_type: 'text', email: { title: "#{title}", body: "#{body}" }
      title = assigns[:subject]
      body = assigns[:body]
      title.should include '[测试商店] 订单 #9999 , 马海波下单'
      body.should include '测试商店'
      body.should include '马海波 新增了订单.'
      body.should include "今天(#{Date.today.to_s(:db)}"
      body.should include '在线支付-支付宝'
      body.should include '普通快递'
      body.should include '广东省 深圳市 南山区 科技园南区6栋311'
      body.should include '518057'
      body.should include '13928452888'
      body.should include '1 x iphone4'
      body.should include '(sku: APPLE1000)'
      title.should_not include 'Liquid error'
      body.should_not include 'Liquid error'
    end

    it "should get ship confirm" do # 发货后通知顾客
      title, body = KeyValues::Mail::Type.find_by_code('ship_confirm').title_body
      get :preview, view_type: 'text', email: { title: "#{title}", body: "#{body}" }
      title = assigns[:subject]
      body = assigns[:body]
      title.should include '订单 #9999 发货提醒'
      body.should include '尊敬的马海波'
      body.should include '1 x iphone4'
      body.should include '通过  顺丰快递 发送到以下地址'
      body.should include '收货人信息: 马海波'
      body.should include '广东省 深圳市 南山区 科技园南区6栋311'
      body.should include '运单号为： 1234' # TODO:显示物流查询链接
      title.should_not include 'Liquid error'
      body.should_not include 'Liquid error'
    end

    it "should get ship update" do # 发货方式修改时通知顾客
      title, body = KeyValues::Mail::Type.find_by_code('ship_update').title_body
      get :preview, view_type: 'text', email: { title: "#{title}", body: "#{body}" }
      title = assigns[:subject]
      body = assigns[:body]
      title.should include '订单 #9999 运送方式更改提醒'
      body.should include '尊敬的马海波'
      body.should include '您的订单号为#9999的商品更改了运送信息'
      body.should include '1 x iphone4'
      body.should include '通过 顺丰快递 运送'
      body.should include '运单号为 1234' # TODO:显示物流查询链接
      title.should_not include 'Liquid error'
      body.should_not include 'Liquid error'
    end

    it "should get order cancelled" do # 订单取消时通知顾客
      title, body = KeyValues::Mail::Type.find_by_code('order_cancelled').title_body
      get :preview, view_type: 'text', email: { title: "#{title}", body: "#{body}" }
      title = assigns[:subject]
      body = assigns[:body]
      title.should include '订单 #9999 取消提醒'
      body.should include '尊敬的马海波'
      body.should include '您的订单#9999已取消！取消原因是:顾客改变/取消订单'
      title.should_not include 'Liquid error'
      body.should_not include 'Liquid error'
    end

  end

end
