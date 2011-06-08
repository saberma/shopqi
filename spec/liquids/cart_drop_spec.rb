#encoding: utf-8
require 'spec_helper'

describe CartDrop do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  context '(empty)' do
    
    let(:assign) { { 'shop' => ShopDrop.new(shop), 'cart' => CartDrop.new({}) } }

    it 'should get item_counts' do
      text = "{{ cart.item_count }}"
      Liquid::Template.parse(text).render(assign).should eql '0'
    end

  end

  context '(has one item)' do
    
    let(:assign) { { 'shop' => ShopDrop.new(shop), 'cart' => CartDrop.new( variant.id => '1') } }

    it 'should get item_counts' do
      text = "{{ cart.item_count }}"
      Liquid::Template.parse(text).render(assign).should eql '1'
    end

    it 'should get items' do
      text = "{{ cart.items | size }}"
      Liquid::Template.parse(text).render(assign).should eql '1'
    end

    it 'should get total_price' do
      text = "{{ cart.total_price }}"
      Liquid::Template.parse(text).render(assign).should eql "#{variant.price}"
    end

    describe LineItemDrop do

      it 'should get product url' do
        text = "{% for item in cart.items %}{{ item.product.url }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "/products/#{iphone4.handle}"
      end

      it 'should get variant id' do
        text = "{% for item in cart.items %}{{ item.variant.id }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "#{variant.id}"
      end

      it 'should get title' do
        text = "{% for item in cart.items %}{{ item.title }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "#{iphone4.title}"
      end

      it 'should get price' do
        text = "{% for item in cart.items %}{{ item.price }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "#{variant.price}"
      end

      it 'should get line_price' do
        text = "{% for item in cart.items %}{{ item.line_price | money }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "#{variant.price}"
      end

      it 'should get quantity' do
        text = "{% for item in cart.items %}{{ item.quantity }}{% endfor %}"
        Liquid::Template.parse(text).render(assign).should eql "1"
      end

    end

  end

end
