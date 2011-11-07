require 'spec_helper'

describe Shop::CartController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  before :each do
    shop.themes.install theme
    request.host = "#{shop.primary_domain.host}"
  end

  context 'exists variant' do

    before :each do
      session = mock('session')
      session.stub!(:[], 'cart').and_return("#{variant.id}|1")
      session.stub!(:[]=)
      controller.stub!(:session).and_return(session)
    end

    it 'should be update' do
      post :update, shop_id: shop.id, updates: [1]
      response.should be_redirect
    end

    it 'should be change' do # 一般用于删除
      get :change, variant_id: variant.id, quantity: 0
      response.should be_redirect
    end

    context '#checkout' do # 结算

      it 'should be submit by button' do
        expect do
          post :update, shop_id: shop.id, updates: {}, checkout: :checkout
        end.should change(Cart, :count).by(1)
      end

      it 'should be submit by image' do
        expect do
          post :update, shop_id: shop.id, updates: {}, 'checkout.x' => 88
        end.should change(Cart, :count).by(1)
      end

    end

  end

  context 'missing variant' do # 款式已在后台管理中删除

    let(:un_exist_variant_id) { 8888 }

    before :each do
      session = mock('session')
      session.stub!(:[], 'cart').and_return("#{un_exist_variant_id}|1")
      session.stub!(:[]=)
      controller.stub!(:session).and_return(session)
    end

    it 'should not be show' do
      get :show
      response.body.should_not include "Liquid error: Couldn't find ProductVariant with id=#{un_exist_variant_id}"
    end

  end

  context 'js', focus: true do

    it 'should be add' do # 商品加入购物车
      post :add, id: variant.id, quantity: 2, format: :js
      response.should be_success
      json = JSON(response.body)
      asset_line_item(json, variant)
    end

    it 'should be show' do # 返回购物车信息
      post :add, id: variant.id, quantity: 2, format: :js
      get :show, format: :js
      response.should be_success
      json = JSON(response.body)
      json.should_not be_empty
      {
        requires_shipping: true,
        total_price: 6000.0,
        attributes: nil,
        item_count: 1,
        note: nil,
        total_weight: 5.8
      }.each_pair do |key, value|
        json[key.to_s].should eql value
      end
      item = json['items'].first
      asset_line_item(item, variant)
    end

    private
    def asset_line_item(item, variant)
      product = variant.product
      item.should_not be_empty
      {
        handle: product.handle,
        line_price: 6000.0,
        requires_shipping: true,
        price: 3000.0,
        title: 'iphone4',
        url: "/products/#{product.handle}",
        quantity: 2,
        id: variant.id,
        grams: 5.8,
        sku: variant.sku,
        vendor: product.vendor,
        image: product.index_photo,
        variant_id: variant.id,
      }.each_pair do |key, value|
        item[key.to_s].should eql value
      end
    end

  end

end
