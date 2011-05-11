# encoding: utf-8
require 'spec_helper'

describe Product do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop, product_type: '智能手机', vendor: 'Apple', tags_text: 'phone,phone,apple' }

  describe Tag do
    it 'should be save' do
      expect do
        iphone4
        iphone4.clone.save
      end.to change(Tag, :count).by(2)
    end
  end
end
