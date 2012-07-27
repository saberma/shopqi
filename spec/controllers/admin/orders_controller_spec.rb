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

  it 'should be cancel' do
    post :cancel, id: order.id, order: { cancel_reason: 'customer' }
    response.should be_redirect
    order.reload
    order.status.should eql 'cancelled'
    order.cancel_reason.should eql 'customer'
    order.cancelled_at.should_not be_nil
  end

  it 'should be destroy' do
    order
    expect do
      delete :destroy, id: order.id
    end.to change(Order, :count).by(-1)
    response.should be_redirect
  end

end
