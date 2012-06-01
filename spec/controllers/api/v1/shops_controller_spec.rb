require 'spec_helper'

describe Api::V1::ShopsController do

  let(:shop) { Factory(:user).shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  context '#show' do

    let(:application) { Factory :themes_application } # OAuth application

    let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id }

    it 'should be success' do
      get :show, format: :json, access_token: token.token
      response.should be_success
      json = JSON(response.body)['shop']
      %w(id name).each do |field|
        json[field].should eql shop.send(field)
      end
    end

    context 'when use bearer header auth', f: true do # oauth2 client 会优先使用 header_format 传递 access_token，格式为 Bearer %s

      it 'should be success' do
        request.env['HTTP_AUTHORIZATION'] = 'Bearer %s' % token.token
        get :show, format: :json
        response.should be_success
        json = JSON(response.body)['shop']
        json['id'].should eql shop.id
      end

    end

  end

  context 'when use http basic auth' do

    let(:api_client) { Factory :api_client, shop: shop }

    context '#show' do

      it 'should be success' do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(api_client.api_key, api_client.password)
        get :show, format: :json
        response.should be_success
        json = JSON(response.body)['shop']
        json['id'].should eql shop.id
      end

    end

  end

end
