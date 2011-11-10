# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Orders", js: true do

  include_context 'use shop'

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:iphone4_variant) { iphone4.variants.first }

  let(:customer_saberma) { Factory :customer_saberma, shop: shop }

  before(:each) do
    visit "/products/#{iphone4.handle}"
    click_on '加入购物车'
  end

  ##### 顾客登录 #####
  describe "Customers" do

    before(:each) do
      shop.update_attributes customer_accounts: :required # 要求用户注册
    end

    it 'should be sign up' do
      visit "/cart"
      click_on '结算'
      page.should have_content('顾客登陆') # 跳转至登录页面
      click_on '注册账号'
      fill_in 'customer[name]'                 , with: '马海波'
      fill_in 'customer[email]'                , with: 'mahb45@gmail.com'
      fill_in 'customer[password]'             , with: '666666'
      fill_in 'customer[password_confirmation]', with: '666666'
      click_on '注册'
      page.should have_content('创建您的订单') # 跳转回结算页面
    end

    it 'should be sign in', focus: true do
      customer_saberma # 已有顾客
      visit "/cart"
      click_on '结算'
      page.should have_content('顾客登陆') # 跳转至登录页面
      fill_in 'customer[email]'                , with: 'mahb45@gmail.com'
      fill_in 'customer[password]'             , with: '666666'
      click_on '登录'
      page.should have_content('创建您的订单') # 跳转回结算页面
    end

  end

end
