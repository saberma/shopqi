#encoding: utf-8
require 'spec_helper'

describe Paginate do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:collection) { CustomCollection.new(title: '所有商品', products: shop.products) }

  let(:collection_drop) { CollectionDrop.new(collection) }

  it 'should get current_page' do
    iphone4
    variant = "{% paginate collection.products by 2 %}{{collection.products | size}},{{paginate.current_page}}{% endpaginate %}"
    assign = { 'collection' => collection_drop, 'current_page' => 1 }
    Liquid::Template.parse(variant).render(assign).should eql "1,1"
  end

  it 'should get current_offset' do # 已经偏移的位数(当前页的起始序号-1)
    iphone4
    variant = "{% paginate collection.products by 1 %}{{paginate.current_offset}}{% endpaginate %}"
    assign = { 'collection' => collection_drop, 'current_page' => 1 }
    Liquid::Template.parse(variant).render(assign).should eql '0'
  end

  it 'should remain the methods' do
    variant = "{% paginate collection.products by 2 %}{{collection.title}}{% endpaginate %}"
    assign = { 'collection' => collection_drop, 'current_page' => 1 }
    Liquid::Template.parse(variant).render(assign).should eql collection.title
  end

end
