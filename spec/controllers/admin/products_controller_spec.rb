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
      attrs = iphone4.attributes
      attrs.delete('shop_id')
      post :create ,:product => attrs
      response.should be_redirect
      flash[:notice].should == "新增商品成功!"
    end

  end

  context '#duplicate' do

    it "should be copy" do
      iphone4.save
      expect do
        post :duplicate , id: iphone4.id, new_title: 'iphone5'
        response.should be_success
      end.should change(Product, :count).by(1)
    end

  end

end
