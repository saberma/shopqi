require 'spec_helper'

describe UrlFilter do

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:asset_host) { 'http://cdn.shopqi.com' }

  before(:each) do
    File.stub!(:mtime).and_return(8888)
    ActionController::Base.stub!(:asset_host).and_return(asset_host)
  end

  it 'should get asset_url' do
    shop.themes.install theme_dark
    variant = "{{ 'ie7.css' | asset_url }}"
    params = { 'shop' => ShopDrop.new(shop) } # 不能使用 { shop: shop }，即key不能为symbol，否则会找不到shop对象
    Liquid::Template.parse(variant).render(params).should eql "#{asset_host}/s/files/#{Rails.env}/#{shop.id}/theme/#{theme.id}/assets/ie7.css?8888"
  end

  it 'should get global_asset_url' do
    variant = "{{ 'textile.css' | global_asset_url }}"
    Liquid::Template.parse(variant).render.should eql "#{asset_host}/s/global/textile.css?8888"
  end

  it 'should get shopqi_asset_url' do
    variant = "{{ 'option_selection.js' | shopqi_asset_url }}"
    Liquid::Template.parse(variant).render.should eql "#{asset_host}/s/shopqi/option_selection.js?8888"
  end

  it 'should get product_img_url' do
    variant = "{{ product.photos.first | product_img_url: 'medium' }}"
    Liquid::Template.parse(variant).render('product' => ProductDrop.new(iphone4)).should eql "#{asset_host}/assets/admin/no-image-medium.gif"
  end

end
