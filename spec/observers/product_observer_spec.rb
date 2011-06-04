# encoding: utf-8
require 'spec_helper'

describe ProductObserver do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  before :each do
    # 删除默认商品，方便测试
    shop.products.clear
    shop.reload
  end

  context '(brand new product type)' do
    it "should be insert" do
      expect do
        expect do
          iphone4
        end.to change(ShopProductType, :count).by(1)
      end.to change(ShopProductVendor, :count).by(1)
    end
  end

  #类型会被自动删除
  context '(exists product type)' do
    it "should be ignore" do
      iphone4
      expect do
        expect do
          iphone4.clone.save
        end.to_not change(ShopProductType, :count)
      end.to_not change(ShopProductVendor, :count)
    end

    #取消唯一关联的类型时，类型会被删除
    it "should be destroy" do
      iphone4
      psp
      expect do
        expect do
          iphone4.update_attributes product_type: '游戏机', vendor: 'Sony'
        end.to change(ShopProductType, :count).by(-1)
      end.to change(ShopProductVendor, :count).by(-1)
    end

    #删除商品或编辑商品时取消唯一关联的类型时，类型会被删除
    context '(destroy product)' do
      it "should be destroy" do
        iphone4
        expect do
          expect do
            iphone4.destroy
          end.to change(ShopProductType, :count).by(-1)
        end.to change(ShopProductVendor, :count).by(-1)
      end
    end
  end
end
