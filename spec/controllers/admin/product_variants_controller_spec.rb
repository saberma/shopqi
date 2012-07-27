#encoding: utf-8
require 'spec_helper'

describe Admin::ProductVariantsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:iphone4) {Factory(:iphone4, shop: shop)}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#create' do

    it "should set default price and weight" do # issue#205
      iphone4
      expect do
        post :create, product_id: iphone4.id, product_variant: {option1: '16G', price: nil, weight: nil}
        response.should be_success
      end.to change(ProductVariant, :count).by(1)
    end

    it "should cant create new variant when sku is limited" do # issue#284
      iphone4
      shop.plan_type.stub!(:skus).and_return(1)
      expect do
        post :create, product_id: iphone4.id, product_variant: {option1: '16G', price: nil, weight: nil}
        response.should be_success
      end.to change(ProductVariant, :count).by(0)
    end
  end

  context '#update' do

    it "should update variant" do # issue#284
      iphone4
      variant = iphone4.variants.first
      expect do
        put :update, product_id: iphone4.id, product_variant: {compare_at_price: "", id: variant.id,  price: "111", product_id: iphone4.id, shop_id: shop.id},  id: variant.id
        response.should be_success
        variant.reload
      end.to change(variant, :price).from(3000).to(111)
    end

    it "should cant update  variant when sku is limited" do # issue#284
      iphone4
      variant = iphone4.variants.first
      shop.plan_type.stub!(:skus).and_return(1)
      expect do
        put :update, product_id: iphone4.id, product_variant: {compare_at_price: "", id: iphone4.variants.first.id,  price: "111", product_id: iphone4.id, shop_id: shop.id},  id: iphone4.variants.first.id
        response.should be_success
        variant.reload
      end.not_to change(variant, :price).from(3000).to(111)
    end

  end

  context '#set' do

    let(:first_variant) { iphone4.variants.first }

    let(:second_variant) { iphone4.variants.create price: 2500.0 }

    before { second_variant }

    it "should be success" do # issue#454
      post :set, product_id: iphone4.id, variants: [first_variant.id, second_variant.id], operation: 'price', new_value: 1000
      response.should be_success
      second_variant.reload.price.should eql 1000.0
    end

  end

end
