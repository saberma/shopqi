#encoding: utf-8
require 'spec_helper'

describe ShopDrop do

  let(:shop) { Factory(:user).shop }

  let(:shop_drop) { ShopDrop.new shop, nil, "#{shop.domains.first.host}" }

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

  it 'should get customer_accounts_enabled' do # 启用顾客功能
    variant = "{{ shop.customer_accounts_enabled }}"
    liquid(variant).should eql "true"
  end

  context 'with products' do

    let(:iphone4) { Factory :iphone4, shop: shop }

    before { iphone4 }

    it 'should get vendors' do
      variant = "{% for v in shop.vendors %}{{ v }}{% endfor %}"
      liquid(variant).should eql "Apple"
    end

    it 'should get types' do
      variant = "{% for t in shop.types %}{{ t }}{% endfor %}"
      liquid(variant).should eql "手机"
    end

    it 'should get domain record' do
      variant = "{{ shop.domain_record }}"
      liquid(variant).should eql Setting.domain.record
    end

  end

  private
  def liquid(variant, assign = {'shop' => shop_drop})
    Liquid::Template.parse(variant).render(assign)
  end

end
