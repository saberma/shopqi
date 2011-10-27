# encoding: utf-8
FactoryGirl.define do

  factory :theme do
    after_create { |theme|
      path = Rails.root.join 'spec', 'factories', 'data', 'themes'
      zip_path = File.join path, 'woodland.tar.bz2'
      screenshot_main_path = File.join path, 'main.jpg'
      screenshot_collection_path = File.join path, 'collection.jpg'
      screenshot_product_path = File.join path, 'product.jpg'
      @uploader = ThemeUploader.new(theme, :file)
      @uploader.store!(File.open(zip_path))
      @main_uploader = ThemeMainUploader.new(theme, :main)
      @main_uploader.store!(File.open(screenshot_main_path))
      @collection_uploader = ThemeCollectionUploader.new(theme, :collection)
      @collection_uploader.store!(File.open(screenshot_collection_path))
      @product_uploader = ThemeProductUploader.new(theme, :product)
      @product_uploader.store!(File.open(screenshot_product_path))
    }
  end

  factory :theme_woodland, parent: :theme do
    name '乔木林地'
    handle 'woodland'
    role 'main'
    desc '乔木林地 是ShopQi官方模板之一，除提供具体模板功能外还提供丰富的自定义配置。'
    shop 'woodland'
    site 'http://www.shopqi.com'
    author 'ShopQi'
    email 'support@shopqi.com'
  end

  factory :theme_woodland_dark, parent: :theme_woodland do
    style '黑桤木'
    style_handle 'dark-alder'
    price 0
    color 'grey'
  end

  factory :theme_woodland_slate, parent: :theme_woodland do
    style '石板'
    style_handle 'slate'
  end

end
