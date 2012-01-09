# encoding: utf-8
require 'spec_helper'

describe TagFilter do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:link_list) { Factory :link_list, shop: shop }

  it 'should get stylesheet_tag' do
    variant = "{{ 'textile.css' | stylesheet_tag }}"
    Liquid::Template.parse(variant).render.should eql "<link href='textile.css' rel='stylesheet' type='text/css' media='all' />"
  end

  it 'should get script_tag' do
    variant = "{{ 'jquery.js' | script_tag }}"
    Liquid::Template.parse(variant).render.should eql "<script src='jquery.js' type='text/javascript'></script>"
  end

  it 'should get img_tag' do
    variant = "{{ 'avatar.jpg' | img_tag }}"
    Liquid::Template.parse(variant).render.should eql "<img src='avatar.jpg' alt='' />"
  end

  it 'should get link_to' do
    link = LinkDrop.new link_list.links.build title: '查询', link_type: 'search', url: '/search'
    variant = "{{ link.title | escape | link_to: link.url }}"
    Liquid::Template.parse(variant).render('link' => link).should eql "<a href='/search'>查询</a>"
  end

  it "should get type url" do
    variant = "{{ product.type | link_to_type}}"
    result = "<a title='#{iphone4.product_type}' href='/collections/types?q=#{iphone4.product_type}'>#{iphone4.product_type}</a>"
    Liquid::Template.parse(variant).render('product' => ProductDrop.new(iphone4)).should eql result
  end

  it "should get vendor url" do
    variant = "{{ vendor | link_to_vendor}}"
    result = "<a title='Cola' href='/collections/vendors?q=Cola'>Cola</a>"
    Liquid::Template.parse(variant).render('vendor' => 'Cola').should eql result
  end

  it "should get errors" do
    variant = "{{ errors | default_errors}}"
    errors = { email: ['不能为空','格式不正确'] }
    result = '<div class="errors"><ul><li> email 不能为空 </li><li> email 格式不正确 </li></ul></div>'
    Liquid::Template.parse(variant).render('errors' => errors).should eql result
    errors = { email: '不能为空' }
    result = '<div class="errors"><ul><li> email 不能为空 </li></ul></div>'
    Liquid::Template.parse(variant).render('errors' => errors).should eql result
  end

  describe Tag do

    context 'within collection' do

      let(:collection) { shop.custom_collections.where(handle: 'frontpage').first }

      let(:iphone4) { Factory :iphone4, shop: shop, collections: [collection], tags_text: '智能 手机 待机时间长'  }

      it "should get link to tag url" do
        variant = "{{ tag | link_to_tag: tag }}"
        result = "<a title='显示有手机标签的商品' href='/collections/frontpage/手机'>手机</a>"
        Liquid::Template.parse(variant).render('tag' => '手机', 'collection' => CollectionDrop.new(collection)).should eql result
      end

      it "should get link to add tag url" do
        variant = "{{ tag | link_to_add_tag: tag }}"
        result = "<a title='显示有待机时间长和手机标签的商品' href='/collections/frontpage/待机时间长+手机'>待机时间长</a>"
        Liquid::Template.parse(variant).render('current_tags' => ['手机'], 'tag' => '待机时间长', 'collection' => CollectionDrop.new(collection)).should eql result
      end

      it "should get link to remove tag url" do
        variant = "{{ tag | link_to_remove_tag: tag }}"
        result = "<a title='取消手机标签' href='/collections/frontpage/待机时间长'>手机</a>"
        Liquid::Template.parse(variant).render('current_tags' => ['待机时间长', '手机'], 'tag' => '手机', 'collection' => CollectionDrop.new(collection)).should eql result
      end

    end

    context 'within types' do # 通过商品类型查询标签

      let(:iphone4) { Factory :iphone4, shop: shop, tags_text: '智能 待机时间长'  }

      let(:collection_drop) { CollectionDrop.new(CustomCollection.new(title: '手机', handle: 'types', products: [iphone4])) }

      it "should get link to tag url" do
        variant = "{{ tag | link_to_tag: tag }}"
        result = "<a title='显示有待机时间长标签的商品' href='/collections/types?q=手机&constraint=待机时间长'>待机时间长</a>"
        Liquid::Template.parse(variant).render('tag' => '待机时间长', 'collection' => collection_drop).should eql result
      end

      it "should get link to add tag url" do
        variant = "{{ tag | link_to_add_tag: tag }}"
        result = "<a title='显示有待机时间长和智能标签的商品' href='/collections/types?q=手机&constraint=待机时间长+智能'>待机时间长</a>"
        Liquid::Template.parse(variant).render('current_tags' => ['智能'], 'tag' => '待机时间长', 'collection' => collection_drop).should eql result
      end

      it "should get link to remove tag url" do
        variant = "{{ tag | link_to_remove_tag: tag }}"
        result = "<a title='取消智能标签' href='/collections/types?q=手机&constraint=待机时间长'>智能</a>"
        Liquid::Template.parse(variant).render('current_tags' => ['待机时间长', '智能'], 'tag' => '智能', 'collection' => collection_drop).should eql result
      end
    end

  end

  describe CustomerDrop do

    it "should get customer_login_link" do
      variant = '{{ "登录" | customer_login_link }}'
      result = "<a href='/account/login' id='customer_login_link'>登录</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer_regist_link" do
      variant = '{{ "注册" | customer_regist_link }}'
      result = "<a href='/account/signup' id='customer_regist_link'>注册</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer_logout_link" do
      variant = '{{ "退出" | customer_logout_link }}'
      result = "<a href='/account/logout' id='customer_logout_link'>退出</a>"
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer edit address link",focus: true do
      variant = '{{ "编辑" | edit_customer_address_link: 1 }}'
      result = %Q{<a href="#" onclick="ShopQi.CustomerAddress.toggleForm(1);return false">编辑</a>}
      Liquid::Template.parse(variant).render().should eql result
    end

    it "should get customer delete address link",focus: true do
      variant = '{{ "删除" | delete_customer_address_link: 1 }}'
      result = %Q{<a href="#" onclick="ShopQi.CustomerAddress.destroy(1);return false">删除</a>}
      Liquid::Template.parse(variant).render().should eql result
    end
  end

end
