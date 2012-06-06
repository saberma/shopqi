# encoding: utf-8
require 'spec_helper'

describe 'Doorkeeper::OAuth::AuthorizationRequest' do

  let(:shop) { Factory(:user).shop }

  let(:application) { Factory :express_application } # OAuth application

  context '#success_redirect_uri' do

    it 'should get shop params' do
      authorize = Doorkeeper::OAuth::AuthorizationRequest.new application, shop, response_type: 'code', redirect_uri: application.redirect_uri
      authorize.authorize
      authorize.success_redirect_uri.should include("&shop=#{shop.shopqi_domain}")
    end

  end

end
