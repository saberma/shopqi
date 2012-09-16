# encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Shop::Products", js:true do

  let(:theme) { Factory :theme_woodland_dark }

  let(:user_admin) {  Factory :user_admin }

  let(:shop) do
    model = user_admin.shop
    model.update_attributes password_enabled: false
    model.themes.install theme
    model
  end

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  let(:payment) { Factory :payment, shop: shop }

  before(:each) { Capybara::Server.manual_host = shop.primary_domain.host }

  after(:each) { Capybara::Server.manual_host = nil }

  context "product do not requires shipping" do # 虚拟商品不需要收货地址

    before do
      payment
      variant.update_attributes requires_shipping: false
    end

    it "should be sell" do
      visit "/products/#{iphone4.handle}"
      click_on '加入购物车'
      click_on '结算'
      page.should have_no_content('收货地址')
      fill_in 'order[email]', with: 'mahb45@gmail.com' # 输入邮箱
      #choose '邮局汇款' # 选择支付方式(只有一种付款方式时默认选中)
      click_on '提交订单'
      page.should have_content("您的订单号为： #1001")
    end

  end

end
