#encoding: utf-8
require 'spec_helper'

describe Admin::ProductsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user_admin) }

  let(:shop) { user.shop }

  let(:iphone4) {Factory.build(:iphone4, shop: shop)}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#create' do

    it "should create new product" do
      expect do
        post :create, product: iphone4.attributes.symbolize_keys.except(:id, :shop_id, :created_at, :updated_at)
        response.should be_redirect
        flash[:notice].should == "新增商品成功!"
      end.to change(Product,:count).by(1)
    end

  end

  context '#duplicate' do

    it "should be copy" do
      iphone4.save
      expect do
        post :duplicate , id: iphone4.id, new_title: 'iphone5'
        response.should be_success
      end.to change(Product, :count).by(1)
    end

  end

end
