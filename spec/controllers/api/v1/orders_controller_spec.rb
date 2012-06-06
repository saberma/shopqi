#encoding: utf-8
require 'spec_helper'

describe Api::V1::OrdersController do

  let(:shop) { Factory(:user).shop }

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

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#index' do

    before do
      fulfillment
      order.reload
    end

    let(:application) { Factory :express_application } # OAuth application

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

    it 'should be success' do
      get :index, format: :json, access_token: token.token
      response.should be_success
      json = JSON(response.body)['orders']
      json.size.should eql 1
      order_json = json.first
      %w(id name note number subtotal_price token total_line_items_price total_price total_weight order_number financial_status financial_status_name fulfillment_status fulfillment_status_name cancel_reason cancelled_at ).each do |field|
        order_json[field].should eql order.send(field)
      end

      fulfillment_json = order_json['fulfillments'].first
      fulfillment = order.fulfillments.first
      %w(id order_id tracking_company tracking_number).each do |field|
        fulfillment_json[field].should eql fulfillment.send(field)
      end
      fulfillment_line_item_json = fulfillment_json['line_items'].first
      fulfillment_line_item = fulfillment.line_items.first
      %w(id product_id name quantity price sku title variant_title vendor).each do |field|
        fulfillment_line_item_json[field].should eql fulfillment_line_item.send(field)
      end
      fulfillment_line_item_json['variant_id'].should eql fulfillment_line_item.product_variant_id

      customer_json = order_json['customer']
      customer = order.customer.reload
      %w(id name email note orders_count total_spent).each do |field|
        customer_json[field].should eql customer.send(field)
      end
    end

  end

end
