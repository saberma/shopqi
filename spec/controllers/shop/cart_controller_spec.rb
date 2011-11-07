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

  context 'js' do

    it 'should be add', focus: true do # 商品加入购物车
      post :add, id: variant.id, quantity: 2, format: :js
      response.should be_success
      json = JSON(response.body)
      json.should_not be_empty
      json['requires_shipping'].should eql true
      json['total_price'].should eql 6000.0
      json['attributes'].should eql nil
      json['item_count'].should eql 1
      json['note'].should eql nil
      json['total_weight'].should eql 5.8
      product = variant.product
      items = json['items'].first
      items.should_not be_empty
      items['handle'].should eql product.handle
      items['line_price'].should eql 6000.0
      items['requires_shipping'].should eql true
      items['price'].should eql 3000.0
      items['title'].should eql 'iphone4'
      items['url'].should eql "/products/#{product.handle}"
      items['quantity'].should eql 2
      items['id'].should eql variant.id
      items['grams'].should eql 5.8
      items['sku'].should eql variant.sku
      items['vendor'].should eql product.vendor
      items['image'].should eql product.index_photo
      items['variant_id'].should eql variant.id
    end

  end

end
