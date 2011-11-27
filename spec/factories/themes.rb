# encoding: utf-8
FactoryGirl.define do

  factory :theme do
    after_create { |theme|
      path = Rails.root.join 'spec', 'factories', 'data', 'themes'
      zip_path = File.join path, 'woodland.tar.bz2'
      screenshot_main_path = File.join path, 'main.jpg'
      screenshot_collection_path = File.join path, 'collection.jpg'
      screenshot_product_path = File.join path, 'product.jpg'
      theme.file = File.open(zip_path)
      theme.main = File.open(screenshot_main_path)
      theme.collection = File.open(screenshot_collection_path)
      theme.product = File.open(screenshot_product_path)
      theme.save
    }
  end

  factory :theme_woodland, parent: :theme do
    name '乔木林地'
    handle 'woodland'
    role 'main'
    color 'grey'
    desc '乔木林地 是ShopQi官方模板之一，除提供具体模板功能外还提供丰富的自定义配置。'
    shop 'woodland'
    site 'http://www.shopqi.com'
    author 'ShopQi'
    email 'support@shopqi.com'
  end

  factory :theme_woodland_slate, parent: :theme_woodland do
    style '石板'
    style_handle 'slate'
  end

  factory :theme_woodland_dark, parent: :theme_woodland do
    style '黑桤木'
    style_handle 'dark-alder'
    price 0
  end

end
