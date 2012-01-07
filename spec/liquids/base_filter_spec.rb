#encoding: utf-8
require 'spec_helper'

describe BaseFilter do

  let(:shop) { Factory(:user).shop }

  let(:shop_drop) { ShopDrop.new shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:product_drop) { ProductDrop.new iphone4 }

  context '#json' do

    it 'should get product' do
      variant = "{{ product | json }}"
      assign = { 'product' => product_drop }
      json_text = Liquid::Template.parse(variant).render(assign)
      json_text.should_not include 'Liquid error'
      json = JSON(json_text)
      json.should_not be_empty
      json['title'].should eql iphone4.title
      json['handle'].should eql iphone4.handle
      json['options'].should eql ['标题']
      variant = iphone4.variants.first
      json['variants'].should eql [
        {
          'id' => variant.id,
          'option1' => '默认标题',
          'option2' => nil,
          'option3' => nil,
          'available' => true,
          'title' => nil,
          'price' => variant.price,
          'compare_at_price' => variant.compare_at_price,
          'weight' => variant.weight,
          'sku' => variant.sku
        },
      ]
    end

  end

  context '#pluralize' do

    it 'should get singular' do
      variant = "{{ 1 | pluralize: 'comment', 'comments' }}"
      result = Liquid::Template.parse(variant).render({})
      result.should eql "comment"
    end

    it 'should get pluralize' do
      variant = "{{ 3 | pluralize: 'comment', 'comments' }}"
      result = Liquid::Template.parse(variant).render({})
      result.should eql "comments"
    end

  end

  context '#money' do

    it 'should get money' do
      variant = "{{ price | money }}"
      assign = { 'price' => 18.8, 'shop' => shop_drop }
      result = Liquid::Template.parse(variant).render(assign)
      result.should eql "&#165;18.8"
    end

    it 'should get money with currency' do
      variant = "{{ price | money_with_currency }}"
      assign = { 'price' => 18.8, 'shop' => shop_drop }
      result = Liquid::Template.parse(variant).render(assign)
      result.should eql "&#165;18.8 元"
    end

    it 'should get money without currency' do
      variant = "{{ price | money_without_currency }}"
      assign = { 'price' => 18.8 }
      result = Liquid::Template.parse(variant).render(assign)
      result.should eql '18.8'
    end

  end

  context '#handleize' do # 用于菜单显示二级菜单(link没有handle，直接将title转为handle后与链接列表的handle比较)

    it 'should be success' do
      variant = "{{ '%@*$如何使用' | handleize }}"
      result = Liquid::Template.parse(variant).render({})
      result.should eql "ru-he-shi-yong"
    end

  end

  context '#camelize ' do # 用于body加入templateIndex等class,Index为当前template名称

    it 'should be success' do
      variant = "{{ 'camel case' | camelize }}"
      result = Liquid::Template.parse(variant).render({})
      result.should eql "CamelCase"
    end

  end

end
