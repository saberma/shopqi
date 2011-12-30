#encoding: utf-8
require 'spec_helper'

describe CollectionsDrop do

  let(:shop) { Factory(:user).shop }

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:smart_collection_low_price){ Factory(:smart_collection_low_price, shop: shop)}

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  let(:psp) { Factory :psp, shop: shop, collections: [frontpage_collection] }

  let(:collections_drop) { CollectionsDrop.new(shop) }

  it "should get all collection" do
    smart_collection_low_price
    iphone4
    collections_drop.all.size.should eql 2
    template = "{% for collection in collections.all %}<span>{{ collection.products.size}}</span>{% endfor %}"
    result = "<span>1</span><span>0</span>"
    Liquid::Template.parse(template).render('collections' => collections_drop).should eql result
  end

  it "should iterate collection", focus: true do
    template = "{% for collection in collections %}<span>{{ collection.title }}</span>{% endfor %}"
    result = "<span>首页商品</span>"
    Liquid::Template.parse(template).render('collections' => collections_drop).should eql result
  end

  context 'frontpage' do

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

  end

  describe CollectionDrop do

    context 'exist' do

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

      it "should get all types" do
        frontpage_collection
        iphone4
        variant = "{% for product_type in collection.all_types %}{{ product_type }}{% endfor %}"
        result = '手机'
        Liquid::Template.parse(variant).render('collection' => CollectionDrop.new(frontpage_collection)).should eql result
      end

      it "should get all vendors" do
        iphone4
        variant = "{% for vendor in collection.all_vendors %}{{ vendor }}{% endfor %}"
        result = 'Apple'
        Liquid::Template.parse(variant).render('collection' => CollectionDrop.new(frontpage_collection)).should eql result
      end

      it "should get all products count and all tags" do
        iphone4.tags_text = '手机，电脑'
        iphone4.save
        frontpage_collection.reload
        psp.tags_text = '电脑，游戏机'
        psp.save
        variant = "{{ collection.all_products_count }} {% for tag in collection.all_tags %},{{ tag }}{% endfor %}"
        Liquid::Template.parse(variant).render('collection' => CollectionDrop.new(frontpage_collection)).should eql '2 ,手机,电脑,游戏机'
      end

      it "should get products count and tags" do
        iphone4.tags_text = '手机,电脑'
        iphone4.save
        frontpage_collection.reload
        psp.tags_text = '电脑,游戏机'
        psp.save
        variant = "{% paginate collection.products by 1 %}{{ collection.products_count }} {% for tag in collection.tags %},{{ tag }}{% endfor %}{% endpaginate %}"
        Liquid::Template.parse(variant).render('collection' => CollectionDrop.new(frontpage_collection)).should eql '1 ,手机,电脑'
      end

      it "should get previous product" do
        iphone4
        frontpage_collection.reload # position递增
        variant = "{{ collection.previous_product }}"
        result = "/collections/frontpage/products/iphone4"
        assign = { 'collection' => CollectionDrop.new(frontpage_collection), 'product' => ProductDrop.new(psp) }
        Liquid::Template.parse(variant).render(assign).should eql result
        assign = { 'collection' => CollectionDrop.new(frontpage_collection), 'product' => ProductDrop.new(iphone4) } # 没有上一个
        Liquid::Template.parse(variant).render(assign).should be_blank
      end

      it "should get next product" do
        psp
        frontpage_collection.reload # position递增
        iphone4
        variant = "{{ collection.next_product }}"
        result = "/collections/frontpage/products/iphone4"
        assign = { 'collection' => CollectionDrop.new(frontpage_collection), 'product' => ProductDrop.new(psp) }
        Liquid::Template.parse(variant).render(assign).should eql result
        assign = { 'collection' => CollectionDrop.new(frontpage_collection), 'product' => ProductDrop.new(iphone4) } # 没有下一个
        Liquid::Template.parse(variant).render(assign).should be_blank
      end

    end

    context 'missing' do

      it 'should get products' do
        variant = "{{ collections.noexist.products.size }}"
        Liquid::Template.parse(variant).render('collections' => CollectionsDrop.new(shop)).should eql '0'
      end

    end

  end

end
