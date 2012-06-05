# encoding: utf-8

FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
  end

  factory :themes_application, parent: :application do
    name 'themes'
    redirect_uri "http://themes.#{Setting.host}/callback"
  end

  factory :express_application, parent: :application do
    name 'express'
    redirect_uri "http://express.shopqiapp.com/callback"
  end
end
