#encoding: utf-8
require 'spec_helper'

describe Api::V1::ProductsController do

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#index' do

    before { [iphone4, psp] }

    let(:application) { Factory :express_application } # OAuth application

    context 'with scopes' do # 资源访问范围匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: "read_products" }

      it 'should be success' do
        get :index, format: :json, access_token: token.token
        response.should be_success
        json = JSON(response.body)['products']
        json.size.should eql 2
        product_json = json.last
        %w(id title body_html handle product_type vendor).each do |field|
          product_json[field].should eql iphone4.send(field)
        end
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

    context 'without scopes' do # 资源访问范围不匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

      it 'should be fail' do # 认证失败
        get :index, format: :json, access_token: token.token
        response.should_not be_success
        response.status.should eql 401
      end

    end


  end

end
