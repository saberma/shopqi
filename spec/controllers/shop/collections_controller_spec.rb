#encoding: utf-8
require 'spec_helper'

describe Shop::CollectionsController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:smart_collection_low_price){ Factory(:smart_collection_low_price,handle: 'low_price', shop: shop)}

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#index' do

    context 'when product published is true' do

      it "should get the index collection url" do
        smart_collection_low_price
        iphone4
        get 'index'
        response.should be_success
        response.body.should have_content('首页商品')
        response.body.should have_content('低价商品')
        response.body.should have_content('共有1件商品')
        response.body.should have_content('共有0件商品')
      end

    end

    context 'when product published is false' do

      it "should view the index collections" do
        smart_collection_low_price
        iphone4.update_attribute :published, false
        get 'index'
        response.should be_success
        response.body.should have_content('首页商品')
        response.body.should have_content('低价商品')
        response.body.should_not have_content('共有1件商品')
        response.body.should have_content('共有0件商品')
      end

    end

  end

  context '#show' do # 显示集合商品

    it "should be success" do
      iphone4
      get 'show', handle: 'frontpage'
      response.should be_success
      response.body.should have_content('首页商品')
      response.body.should have_content('iphone4')
    end

    it "should only show the published collection" do
      smart_collection_low_price
      get 'index'
      response.body.should have_content('低价商品')
      get 'show', handle: 'low_price'
      response.body.should_not have_content("此页面不存在")
      smart_collection_low_price.update_attribute :published, false
      iphone4
      get 'index'
      response.body.should_not have_content('低价商品')
      get 'show', handle: 'low_price'
      response.body.should have_content("此页面不存在")
      response.body.should_not have_content('低价商品')
    end

  end

  context '#show_with_types_or_vendors' do # 显示某个商品类型或厂商的所有商品

    it "should show the assign type product" do
      iphone4
      get 'show_with_types_or_vendors', handle: 'types', q: '手机'
      response.should be_success
      response.body.should have_content('手机')
      response.body.should have_content('iphone4')
    end

    it "should show the assign vendor product" do
      iphone4
      get 'show_with_types_or_vendors', handle: 'vendors', q: 'Apple'
      response.should be_success
      response.body.should have_content('Apple')
      response.body.should have_content('iphone4')
    end

    context '#with_tag', f: true do # 结合标签过滤商品

      let(:iphone4) { Factory :iphone4, shop: shop, product_type: '手持设备', tags_text: '手机, 游戏机, 带拍照功能' }

      let(:psp) { Factory :psp, shop: shop, product_type: '手持设备', tags_text: '游戏机, 带拍照功能' }

      let(:leika) { Factory :leika, shop: shop, product_type: '手持设备', tags_text: '相机, 带拍照功能' }

      before do
        [iphone4, psp]
        path = shop.theme.template_path('collection')
        File.open(path, 'w') {|f| f.write("{% for tag in current_tags %}{{ tag }} {% endfor %} - {% for product in collection.products %}{{ product.title }} {% endfor %}") }
      end

      context '#single' do # 单个标签

        it "should be success" do
          get 'show_with_types_or_vendors', handle: 'types', q: '手持设备', constraint: '手机'
          response.body.should have_content('手机') # current_tags
          response.body.should have_content('iphone4')
          response.body.should_not have_content('psp')
        end

      end

      context '#multi' do # 多个标签

        it "should be success" do
          leika
          get 'show_with_types_or_vendors', handle: 'types', q: '手持设备', constraint: '游戏机+带拍照功能'
          response.body.should have_content('游戏机 带拍照功能') # current_tags
          response.body.should have_content('iphone4')
          response.body.should have_content('psp')
          response.body.should_not have_content('leika')
        end

      end

    end

  end

  context '#show_with_tag' do # 结合标签过滤集合商品

    let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection], tags_text: '手机, 游戏机, 带拍照功能' }

    let(:psp) { Factory :psp, shop: shop, collections: [frontpage_collection], tags_text: '游戏机, 带拍照功能' }

    let(:leika) { Factory :leika, shop: shop, collections: [frontpage_collection], tags_text: '相机, 带拍照功能' }

    before do
      [iphone4, psp]
      path = shop.theme.template_path('collection')
      File.open(path, 'w') {|f| f.write("{% for tag in current_tags %}{{ tag }} {% endfor %} - {% for product in collection.products %}{{ product.title }} {% endfor %}") }
    end

    context '#single' do # 单个标签

      it "should be success" do
        get 'show_with_tag', handle: frontpage_collection.handle, tags: '手机'
        response.body.should have_content('手机') # current_tags
        response.body.should have_content('iphone4')
        response.body.should_not have_content('psp')
      end

    end

    context '#multi' do # 多个标签

      it "should be success" do
        leika
        get 'show_with_tag', handle: frontpage_collection.handle, tags: '游戏机+带拍照功能'
        response.body.should have_content('游戏机 带拍照功能') # current_tags
        response.body.should have_content('iphone4')
        response.body.should have_content('psp')
        response.body.should_not have_content('leika')
      end

    end

  end

end
