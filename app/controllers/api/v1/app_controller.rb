# encoding: utf-8
module Api::V1
  class AppController < ActionController::Base
    before_filter :http_basic_authenticate
    layout nil
    doorkeeper_for :all, unless: lambda { @api_client }

    def shop
      return Shop.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      @api_client.shop if @api_client
    end

    protected

    def http_basic_authenticate # 是否使用 http basic auth 进行认证
      return if request.authorization.blank? or !request.authorization.start_with?('Basic')
      @api_client = authenticate_with_http_basic do |username, password|
        Shop.at(request.host).api_clients.where(api_key: username, password: password).first
      end
    end
  end

end
