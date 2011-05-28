require 'spec_helper'

describe UrlFilter do

  let(:shop) { Factory(:user).shop }

  it 'should get asset_url' do
    variant = "{{ 'shop.css' | asset_url }}"
    params = { 'shop' => ShopDrop.new(shop) } # 不能使用 { shop: shop }，即key不能为symbol，否则会找不到shop对象
    Liquid::Template.parse(variant).render(params).should eql "/themes/#{shop.id}/assets/shop.css"
  end

  it 'should get global_asset_url' do
    variant = "{{ 'textile.css' | global_asset_url }}"
    Liquid::Template.parse(variant).render.should eql '/global/textile.css'
  end

end
