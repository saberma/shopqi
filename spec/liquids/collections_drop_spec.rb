#encoding: utf-8
require 'spec_helper'

describe CollectionsDrop do

  let(:shop) { Factory(:user).shop }

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:smart_collection_low_price){ Factory(:smart_collection_low_price, shop: shop)}

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  context 'frontpage' do

    let(:collections_drop) { CollectionsDrop.new(shop) }

    it 'should get handle' do
      variant = "{{collections.frontpage.handle}}"
      result = "frontpage"
      Liquid::Template.parse(variant).render('collections' => collections_drop).should eql result
    end

    it 'should get products' do
      iphone4
      variant = "{% for product in collections.frontpage.products %}<span>{{ product.title }}</span>{% endfor %}"
      result = "<span>#{iphone4.title}</span>"
      Liquid::Template.parse(variant).render('collections' => collections_drop).should eql result
      iphone4.update_attribute :published,false
      variant = "{% if collections.frontpage.products.size == 0 %}<span>没有商品</span>{% endif %}"
      result = "<span>没有商品</span>"
      Liquid::Template.parse(variant).render('collections' => collections_drop).should eql result
    end

    it "should get all collection" do
      smart_collection_low_price
      iphone4
      collections_drop.all.size.should eql 2
      template = "{% for collection in collections.all %}<span>{{ collection.products.size}}</span>{% endfor %}"
      result = "<span>1</span><span>0</span>"
      Liquid::Template.parse(template).render('collections' => collections_drop).should eql result
    end

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
