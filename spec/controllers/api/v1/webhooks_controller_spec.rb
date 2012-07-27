#encoding: utf-8
require 'spec_helper'

describe Api::V1::WebhooksController do

  let(:shop) { Factory(:user).shop }

  before :each do
    Timecop.freeze(Time.now)
    request.host = "#{shop.primary_domain.host}"
  end

  after { Timecop.return }

  context '#create' do

    let(:application) { Factory :express_application } # OAuth application

    context 'with scopes' do # 资源访问范围匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: "write_orders" }

      it 'should be success' do
        expect do
          post :create, webhook: {event: 'orders/fulfilled', callback_url: 'express.shopqiapp.com'}, format: :json, access_token: token.token
          response.should be_success
          assigns[:webhook].application_id.should eql application.id # 通过 API 创建的记录要关联到应用
          pattern = {
            webhook: {
              id: 1,
              event: "orders/fulfilled",
              callback_url: "express.shopqiapp.com"
            }
          }
          response.body.should match_json_expression(pattern)
        end.to change(Webhook, :count).by(1)
      end

      context 'wrong event' do

        it 'should be error' do
          expect do
            post :create, webhook: {event: 'orders/no-exists', callback_url: 'express.shopqiapp.com'}, format: :json, access_token: token.token
            response.should be_success
            json = JSON(response.body)
            json['errors'].should_not be_nil
          end.should_not change(Webhook, :count)
        end
      
      end

    end

    context 'without scopes' do # 资源访问范围不匹配

      let(:token) { Factory :access_token, application: application, resource_owner_id: shop.id, scopes: "write_products"  }

      it 'should be fail' do # 认证失败
        expect do
          post :create, webhook: {event: 'orders/fulfilled', callback_url: 'express.shopqiapp.com'}, format: :json, access_token: token.token
          response.should_not be_success
          response.status.should eql 401
        end.should_not change(Webhook, :count)
      end

    end

  end

end
