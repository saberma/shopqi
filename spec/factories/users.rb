# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
    email 'admin@shopqi.com'
    shop_attributes({
      name: '测试商店',
      email: 'admin@shopqi.com'
      domains_attributes: [{subdomain: 'shopqi', domain: Setting.store_host}]
    })
    password '666666'
    password_confirmation '666666'
  end

  factory :user_admin, :parent => :user do
    email 'admin@shopqi.com'
    name 'admin'
  end

  factory :user_saberma, :parent => :user_admin do
    email 'mahb45@gmail.com'
    name 'saberma'
  end

  factory :user_liwh, :parent => :user_admin do
    email 'liwh87@gmail.com'
    name 'liwh'
  end

end
