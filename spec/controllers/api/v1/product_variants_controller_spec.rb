#encoding: utf-8
require 'spec_helper'

describe Api::V1::ProductVariantsController do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:body) { {id: variant.id, price: 45 }} # modify to

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#update' do

    before { [iphone4] }

    let(:application) { Factory :express_application } # OAuth application

    context 'with scopes' do # 资源访问范围匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: "write_products" }

      it 'should be success' do
        put :update, id: variant.id, variant: body, format: :json, access_token: token.token
        response.should be_success
        json = JSON(response.body)['variant']
        pattern = {
          id: variant.id,
          product_id: iphone4.id,
          price: 45.0,
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
        }
        json.should match_json_expression(pattern)
      end

    end

    context 'without scopes' do # 资源访问范围不匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

      it 'should be fail' do # 认证失败
        put :update, id: variant.id, variant: body, format: :json, access_token: token.token
        response.should_not be_success
        response.status.should eql 401
      end

    end


  end

end
