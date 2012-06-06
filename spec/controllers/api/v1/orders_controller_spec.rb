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

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#index' do

    before { order }

    let(:application) { Factory :express_application } # OAuth application

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

    it 'should be success' do
      get :index, format: :json, access_token: token.token
      response.should be_success
      json = JSON(response.body)['orders']
      json.size.should eql 1
      order_json = json.first
      %w(id name note number subtotal_price token total_line_items_price total_price total_weight order_number cancel_reason cancelled_at ).each do |field|
        order_json[field].should eql order.send(field)
      end
    end

  end

end
