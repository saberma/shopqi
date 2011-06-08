require 'spec_helper'

describe UrlFilter do

  let(:shop) { Factory(:user).shop }

  it 'should get asset_url' do
    variant = "{{ 'shop.css' | asset_url }}"
    params = { 'shop' => ShopDrop.new(shop) } # 不能使用 { shop: shop }，即key不能为symbol，否则会找不到shop对象
    Liquid::Template.parse(variant).render(params).should eql "/s/files/#{Rails.env}/#{shop.id}/theme/assets/shop.css"
  end

  it 'should get global_asset_url' do
    variant = "{{ 'textile.css' | global_asset_url }}"
    Liquid::Template.parse(variant).render.should eql '/s/global/textile.css'
  end

  it 'should get shopqi_asset_url' do
    variant = "{{ 'option_selection.js' | shopqi_asset_url }}"
    Liquid::Template.parse(variant).render.should eql '/s/shopqi/option_selection.js'
  end

  it 'should get product_img_url' do
    variant = "{{ '/products/1.png' | product_img_url: 'medium' }}"
    Liquid::Template.parse(variant).render.should eql '/products/1-medium.png'
  end

end
