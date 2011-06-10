#encoding: utf-8
require 'spec_helper'

describe Paginate do

  let(:shop) { Factory(:user).shop }

  let(:collection) { CustomCollection.new(title: '所有商品', products: shop.products) }

  let(:collection_drop) { CollectionDrop.new(collection) }

  it 'should get current_page' do
    variant = "{% paginate collection.products by 2 %}{{collection.products | size}},{{paginate.current_page}}{% endpaginate %}"
    assign = { 'collection' => collection_drop, 'current_page' => 2 }
    Liquid::Template.parse(variant).render(assign).should eql "2,2"
  end

  it 'should remain the methods' do
    variant = "{% paginate collection.products by 2 %}{{collection.title}}{% endpaginate %}"
    assign = { 'collection' => collection_drop, 'current_page' => 2 }
    Liquid::Template.parse(variant).render(assign).should eql collection.title
  end

end
