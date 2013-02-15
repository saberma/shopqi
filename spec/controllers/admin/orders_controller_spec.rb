#encoding: utf-8
require 'spec_helper'

describe Admin::OrdersController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:payment) { Factory :payment, shop: shop }

  let(:order) do
    o = Factory.build :order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment.id
    o.line_items.build product_variant: variant, price: 10, quantity: 2
    o.save
    o
  end

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should be close' do
    post :close, id: order.id
    response.should be_redirect
    order.reload
    order.status.should eql 'closed'
    order.closed_at.should_not be_nil
  end

  it 'should be open' do
    post :open, id: order.id
    response.should be_redirect
    order.reload
    order.status.should eql 'open'
    order.closed_at.should be_nil
  end

  it 'should be destroy' do
    order
    expect do
      delete :destroy, id: order.id
    end.to change(Order, :count).by(-1)
    response.should be_redirect
  end

  context '#cancel' do

    it 'should be success' do
      post :cancel, id: order.id, order: { cancel_reason: 'customer' }
      response.should be_redirect
      order.reload
      order.status.should eql 'cancelled'
      order.cancel_reason.should eql 'customer'
      order.cancelled_at.should_not be_nil
    end

    context 'with refund' do # 退款

      it 'should create transaction' do
        expect do
          post :cancel, id: order.id, order: { cancel_reason: 'customer' }, refund: true
        end.to change(OrderTransaction, :count).by(1)
      end

    end

    context 'without refund' do # 无须退款

      it 'should create transaction' do
        expect do
          post :cancel, id: order.id, order: { cancel_reason: 'customer' }
        end.not_to change(OrderTransaction, :count)
      end

    end

  end

  context 'online pay' do # 在线支付

    let(:payment) { Factory :payment_alipay, shop: shop } # 支付方式:支付宝即时到帐

    context 'refund' do # 退款

      let(:trade_no) { '2012041441700373' }

      let(:notify_id) { '123456' }

      let(:transaction) { order.refund! }

      context '#alipay_refund_notify' do # 支付宝从后台发送通过

        before do
          WebMock.disable_net_connect!
          stub_request(:get, "https://mapi.alipay.com/gateway.do?notify_id=#{notify_id}&partner=#{payment.account}&service=notify_verify").to_return(body: 'true')
          order.trade_no = trade_no
          order.save
        end

        after { WebMock.allow_net_connect! }

        context 'status is success' do # 退款成功

          let(:attrs) { { batch_no: transaction.batch_no, success_num: '1', notify_id: notify_id, result_details: "#{trade_no}^#{order.total_price}^SUCCESS"} }

          it 'should change order financial_status to refunded' do
            post :alipay_refund_notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            order.reload.financial_status_refunded?.should be_true
            transaction.reload.status.should eql 'success'
          end

        end

        context 'status is fail' do # 退款失败

          let(:attrs) { { batch_no: transaction.batch_no, success_num: '0', notify_id: notify_id, result_details: "#{trade_no}^#{order.total_price}^HAS_NO_PRIVILEGE"} }

          it 'should change not order financial_status' do
            post :alipay_refund_notify, attrs.merge(sign_type: 'md5', sign: sign(attrs, order.payment.key))
            order.financial_status_refunded?.should be_false
            transaction.reload.status.should eql 'failure'
          end

        end

      end

    end

  end

end
