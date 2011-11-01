#encoding: utf-8
require 'spec_helper'

describe ShopDrop do

  let(:shop) { Factory(:user).shop }

  let(:shop_drop) { ShopDrop.new shop }

  it 'should get url' do
    variant = "{{ shop.url }}"
    liquid(variant).should eql "http://shopqi.lvh.me"
  end

  #it 'should get asset_url' do
  #  variant = "{{ 'stylesheet.css' | shop.asset_url }}"
  #  liquid(variant).should eql "stylesheet.css"
  #end

  it 'should get money format' do
    variant = "{{ shop.money_with_currency_format }}"
    liquid(variant).should eql "&#165;{{amount}} 元"
  end

  private
  def liquid(variant, assign = {'shop' => shop_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end
