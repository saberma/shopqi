# encoding: utf-8

FactoryGirl.define do
  factory :oauth2_client, class: OAuth2::Model::Client do
    name 'themes'
    redirect_uri "http://themes.#{Setting.host}/callback"
  end
end
