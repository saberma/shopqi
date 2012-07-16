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

  let(:application) { Factory :express_application } # OAuth application

  before do
    Timecop.freeze(Time.now)
    request.host = "#{shop.primary_domain.host}"
    fulfillment
    order.reload
  end

  after { Timecop.return }

  context 'with scopes' do # 资源访问范围匹配

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: 'read_orders' }

    context 'index' do

      it 'should be success' do
        get :index, format: :json, access_token: token.token
        response.should be_success
        json = JSON(response.body)['orders']
        json.size.should eql 1
        order_json = json.first
        asset_json(order_json)
      end

      it 'should be paginate' do # page, per_page
        get :index, format: :json, access_token: token.token, page: 2, per_page: 1
        response.should be_success
        json = JSON(response.body)['orders']
        json.size.should eql 0
      end

    end

    context 'show' do

      it 'should be success' do
        get :show, id: order.id, format: :json, access_token: token.token
        order_json = JSON(response.body)['order']
        asset_json(order_json)
      end
    end

  end

  context 'without scopes' do # 资源访问范围不匹配

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

    it 'should not be index' do
      get :index, format: :json, access_token: token.token
      response.should_not be_success
      response.status.should eql 401
    end

    it 'should not be show' do
      get :show, id: order.id, format: :json, access_token: token.token
      response.should_not be_success
      response.status.should eql 401
    end

  end

  private
  def asset_json(order_json)
    pattern = {
      id: 1,
      name: '#1001',
      note: nil,
      number: 1,
      subtotal_price: 20.0,
      token: order.token,
      total_line_items_price: 20.0,
      total_price: 30.0,
      total_weight: 5800,
      order_number: 1001,
      financial_status: "pending",
      financial_status_name: "待支付",
      fulfillment_status: "fulfilled",
      fulfillment_status_name: "已发货",
      cancel_reason: nil,
      cancelled_at: nil,
      created_at: Time.now.iso8601,
      updated_at: Time.now.iso8601,
      transactions: [],
      fulfillments: [{
        id: 1,
        order_id: 1,
        tracking_company: nil,
        tracking_number: nil,
        created_at: Time.now.iso8601,
        updated_at: Time.now.iso8601,
        line_items: [{
          id: 1,
          product_id: 1,
          name: "iphone4",
          quantity: 2,
          price: 10.0,
          sku: "APPLE1000",
          title: "iphone4",
          variant_id: 1,
          variant_title: nil,
          vendor: "Apple"}]}],
      customer: {
        id: 1,
        name: "马海波",
        email: "admin@shopqi.com",
        note: nil,
        orders_count: 1,
        total_spent: 0.0,
        created_at: Time.now.iso8601,
        updated_at: Time.now.iso8601}
    }
    order_json.should match_json_expression(pattern)
  end

end
