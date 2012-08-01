#encoding: utf-8
require 'spec_helper'

describe Discount do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:cart) { Factory :cart, shop: shop, cart_hash: %Q({"#{variant.id}":1}) }

  let(:discount) { shop.discounts.create code: 'coupon123' }

  context '#apply' do # 提交优惠码

    context 'remain 0 times' do # 优惠码剩余次数不足

      let(:discount) do
        model = shop.discounts.create code: 'coupon123', usage_limit: 1
        model.used_times = 1
        model.save
        model
      end

      it 'should be faild' do
        json = shop.discounts.apply(code: discount.code, cart: cart)
        json[:code].should be nil
      end

    end

    context 'remain more times' do # 优惠码剩余次数充足

      it 'should be success' do
        json = shop.discounts.apply(code: discount.code, cart: cart) # 不限使用次数
        json[:code].should eql discount.code
        discount.update_attributes! usage_limit: 1 # 限制使用次数
        json = shop.discounts.apply(code: discount.code, cart: cart)
        json[:code].should eql discount.code
      end

    end

  end
end
