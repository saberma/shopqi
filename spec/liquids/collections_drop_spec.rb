#encoding: utf-8
require 'spec_helper'

describe CollectionsDrop do

  let(:shop) { Factory(:user).shop }

  let(:frontpage_collection) { shop.custom_collections.where(handle: :frontpage).first }

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  it 'should get frontpage' do
    iphone4
    variant = "{% for product in collections.frontpage.products %}<span>{{ product.title }}</span>{% endfor %}"
    result = "<span>#{iphone4.title}</span>"
    Liquid::Template.parse(variant).render('collections' => CollectionsDrop.new(shop)).should eql result
  end

  describe CollectionDrop do

    let(:collection) { Factory(:custom_collection, shop: shop) }

    let(:collection_drop) { CollectionDrop.new collection }

    it 'should get title' do
      variant = "{{ collection.title }}"
      result = collection.title
      Liquid::Template.parse(variant).render('collection' => collection_drop).should eql result
    end

    it 'should get description' do
      variant = "{{ collection.description }}"
      result = collection.body_html
      Liquid::Template.parse(variant).render('collection' => collection_drop).should eql result
    end

  end

end
