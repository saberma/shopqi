require 'spec_helper'

describe OrdersController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:order) do
    o = Factory.build(:order, shop: shop)
    o.line_items.build product_variant: variant, price: 10, quantity: 2
    o.save
    o
  end

  before :each do
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
    end.should change(Order, :count).by(-1)
    response.should be_redirect
  end

end
