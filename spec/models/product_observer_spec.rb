# encoding: utf-8
require 'spec_helper'

describe ProductObserver do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple' }

  context '(brand new product type)' do
    it "should be insert" do
      expect do
        expect do
          iphone4
        end.to change(ShopProductType, :count).by(1)
      end.to change(ShopProductVendor, :count).by(1)
    end
  end

  context '(exists product type)' do
    it "should be ignore" do
      iphone4
      expect do
        expect do
          iphone4.clone.save
        end.to_not change(ShopProductType, :count)
      end.to_not change(ShopProductVendor, :count)
    end
  end
end
