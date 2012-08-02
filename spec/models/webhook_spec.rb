#encoding: utf-8
require 'spec_helper'

describe Webhook do

  let(:shop) { Factory(:user).shop }

  let(:application) { Factory :express_application } # OAuth application

  before { WebMock.disable_net_connect! }

  context 'orders fulfilled' do # 订单发货

    let(:webhook) { Factory(:webhook_orders_fulfilled, shop: shop, application_id: application.id) } # 通过应用创建

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

    before { Timecop.freeze(Time.now) }

    after { Timecop.return }

    it 'should be invoke' do
      stub_request(:post, "express.shopqiapp.com")
      webhook
      with_resque do
        fulfillment
      end
      data = Rabl::Renderer.json(order.reload, 'api/v1/orders/show', view_path: 'app/views')
      headers = {
        X_SHOPQI_EVENT: 'orders/fulfilled',
        X_SHOPQI_DOMAIN: shop.shopqi_domain,
        X_SHOPQI_ORDER_ID: order.id.to_s,
        X_SHOPQI_HMAC_SHA256: sign_hmac(application.secret, data),
      }
      a_request(:post, "express.shopqiapp.com").with(headers: headers).should have_been_made
    end

  end

end
