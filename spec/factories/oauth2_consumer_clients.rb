# encoding: utf-8

FactoryGirl.define do
  factory :oauth2_consumer_client, class: OAuth2::Model::ConsumerClient do
    name 'themes'
  end
end
