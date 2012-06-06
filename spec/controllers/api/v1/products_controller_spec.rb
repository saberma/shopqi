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

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

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

  end

end
