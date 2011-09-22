#encoding: utf-8
require 'spec_helper'

describe Shop::CollectionsController do

  let(:shop) do
    model = Factory(:user_admin).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:smart_collection_low_price){ Factory(:smart_collection_low_price,handle: 'low_price', shop: shop)}

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

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

  it "should show the frontpage collection products" do
    iphone4
    get 'show', handle: 'frontpage'
    response.should be_success
    response.body.should have_content('首页商品')
    response.body.should have_content('iphone4')
  end

  it "should show the assign type product" do
    iphone4
    get 'show', handle: 'types', q: '手机'
    response.should be_success
    response.body.should have_content('手机')
    response.body.should have_content('iphone4')
  end

  it "should show the assign vendor product" do
    iphone4
    get 'show', handle: 'vendors', q: 'Apple'
    response.should be_success
    response.body.should have_content('Apple')
    response.body.should have_content('iphone4')
  end

  it "should only show the published collection" do
    smart_collection_low_price
    get 'index'
    response.body.should have_content('低价商品')
    get 'show',handle: 'low_price'
    response.body.should_not have_content("We're really sorry")
    smart_collection_low_price.update_attribute :published, false
    iphone4
    get 'index'
    response.body.should_not have_content('低价商品')
    get 'show',handle: 'low_price'
    response.body.should have_content("We're really sorry")
    response.body.should_not have_content('低价商品')
  end

end
