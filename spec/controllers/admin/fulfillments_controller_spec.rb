#encoding: utf-8
require 'spec_helper'

describe Admin::FulfillmentsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  let(:iphone_variant) { iphone4.variants.first }

  let(:psp_variant) { psp.variants.first }

  let(:payment) { Factory :payment, shop: shop }

  let(:order) do
    o = Factory.build(:order, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment.id)
    o.line_items.build product_variant: iphone_variant, price: 10, quantity: 2
    o.line_items.build product_variant: psp_variant, price: 20, quantity: 3
    o.save
    o
  end

  let(:iphone_line_item) { order.line_items.first }

  let(:psp_line_item) { order.line_items.second }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should set line_items' do
    expect do
      post :set, order_id: order.id, shipped: [ iphone_line_item.id, psp_line_item.id ]
      JSON(response.body)['fulfillment_status'].to_sym.should eql :fulfilled
      [iphone_line_item, psp_line_item].each do |line_item|
        line_item.reload.fulfilled.should be_true
        line_item.fulfillment.should_not be_nil
      end
      order.reload.fulfillment_status.to_sym.should eql :fulfilled
    end.to change(OrderFulfillment, :count).by(1)
  end

end
