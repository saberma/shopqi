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

    it 'should be add' do
      iphone4.options_attributes = [
        {name: '大小', value: '默认大小'}
      ]
      iphone4.save
      iphone4.variants.first.option2.should eql '默认大小'
    end

    it 'should be destroy' do
      iphone4.options_attributes = [
        {name: '大小', value: '默认大小'}
      ]
      iphone4.save
      option = iphone4.options.second
      option.value.should eql '默认大小'
      iphone4.options_attributes = [
        {id: option.id, _destroy: true}
      ]
      iphone4.save
      iphone4.options.reject! {|option| option.marked_for_destruction?} #rails bug，使用_destroy标记删除后，需要reload后，删除集合中的元素才消失
      iphone4.options.size.should eql 1
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
