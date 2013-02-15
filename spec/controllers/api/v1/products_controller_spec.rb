#encoding: utf-8
require 'spec_helper'

describe Api::V1::ProductsController do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  before :each do
    Timecop.freeze(Time.now)
    request.host = "#{shop.primary_domain.host}"
  end

  after { Timecop.return }

  before { [iphone4, psp] }

  let(:application) { Factory :express_application } # OAuth application

  context 'with scopes' do # 资源访问范围匹配

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: "read_products" }

    context '#index' do

      it 'should be success' do
        get :index, format: :json, access_token: token.token
        response.should be_success
        json = JSON(response.body)['products']
        json.size.should eql 2
        product_json = json.last
        asset_json(product_json)
      end

      it 'should be paginate' do # page, per_page
        get :index, format: :json, access_token: token.token, page: 2, per_page: 1
        response.should be_success
        json = JSON(response.body)['products']
        json.size.should eql 1
        product_json = json.first
        product_json['id'] = iphone4.id
      end

    end

    context 'show' do

      it 'should be success' do
        get :show, id: iphone4.id, format: :json, access_token: token.token
        product_json = JSON(response.body)['product']
        asset_json(product_json)
      end
    end

  end

  context 'without scopes' do # 资源访问范围不匹配

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

    it 'should not be index' do
      get :index, format: :json, access_token: token.token
      response.should_not be_success
      response.status.should eql 401
    end

    it 'should not be show' do
      get :show, id: iphone4.id, format: :json, access_token: token.token
      response.should_not be_success
      response.status.should eql 401
    end

  end

  private
  def asset_json(product_json)
    pattern = {
      id: 1,
      title: "iphone4",
      body_html: "iphone 4是一款基于WCDMA制式的3G手机",
      handle: "iphone4",
      product_type: "手机",
      vendor: "Apple",
      created_at: WILDCARD_MATCHER,
      updated_at: WILDCARD_MATCHER,
      variants: [{
        id: 1,
        product_id: 1,
        price: 3000.0,
        compare_at_price: 3500.0,
        weight: 2.9,
        sku: "APPLE1000",
        position: 1,
        option1: "默认标题",
        option2: nil,
        option3: nil,
        requires_shipping: true,
        inventory_quantity: nil,
        inventory_management: nil,
        inventory_policy: "deny",
        created_at: WILDCARD_MATCHER,
        updated_at: WILDCARD_MATCHER
      }]
    }
    product_json.should match_json_expression(pattern)
  end

end
