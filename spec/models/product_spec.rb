# encoding: utf-8
require 'spec_helper'

describe Product do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple' }

  describe 'Option' do
    it 'should be save' do
      iphone4.options.first.name.should eql '标题'
      iphone4.variants.first.option1.should eql '默认标题'
    end
  end

  describe Tag do
    it 'should be save' do
      expect do
        iphone4
        Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple'
      end.to change(Tag, :count).by(2)
    end
  end
end
