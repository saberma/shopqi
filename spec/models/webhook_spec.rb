#encoding: utf-8
require 'spec_helper'

describe Webhook do

  let(:shop) { Factory(:user).shop }

  context 'orders fulfilled' do # 订单发货

    let(:webhook) { Factory(:webhook_orders_fulfilled, shop: shop) }

    let(:iphone4) { Factory :iphone4, shop: shop }

    let(:variant) { iphone4.variants.first }

    let(:payment) { Factory :payment, shop: shop }

    let(:order) do
      o = Factory.build(:order, shop: shop, email: 'admin@shopqi.com', shipping_rate: '普通快递-10.0', payment_id: payment.id)
      o.line_items.build product_variant: variant, price: 10, quantity: 2
      o.save
      o
    end

    let(:line_item) { order.line_items.first }

    let(:fulfillment) do
      record = order.fulfillments.build notify_customer: 'false'
      record.line_items << line_item
      record.save
      record
    end

    it 'should be invoke' do
      stub = stub_request(:post, "express.shopqiapp.com").with(body: order.to_json).to_return(body: 'a')
      webhook
      fulfillment
      stub.should have_been_requested
    end

  end

end
