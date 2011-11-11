#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'
require 'subdomain_capybara_server'

describe "Shop::Customers", js: true do

  include_context 'use shop'

  let(:iphone4) { Factory :iphone4, shop: shop }
  let(:iphone4_variant) { iphone4.variants.first }
  let(:customer_liwh) { Factory :customer_liwh, shop: shop }

  let(:psp) { Factory :psp, shop: shop }
  let(:psp_variant) { psp.variants.first }
  let(:order) {
    o = Factory.build(:order_liwh, shop: shop)
    o.line_items.build [
      {product_variant: iphone4_variant, price: 10, quantity: 2},
      {product_variant: psp_variant, price: 20, quantity: 2},
    ]
    o.save
    o
  }
  before(:each) { Capybara::Server.manual_host = shop.primary_domain.host }
  after(:each) { Capybara::Server.manual_host = nil }

  describe "GET /account" do  #顾客登陆页面
    it "should can login with a exist customer" do
      customer_liwh
      order
      visit '/account/login'

      fill_in 'customer[email]', with: customer_liwh.email
      fill_in 'customer[password]', with: '666666'
      within '#customer' do # 商店顶端还有一个登录链接，避免冲突
        click_on '登录'
      end
      within '#customer_detail' do
        has_content?('李卫辉').should be_true
        has_content?('广东省').should be_true
        has_content?('深圳市').should be_true
        has_content?('南山区').should be_true
        has_content?('查看地址簿(1)').should be_true
      end

      within '#customer_orders' do
        has_content?('#1001').should be_true
        has_content?('放弃').should be_true
        has_content?('未发货').should be_true
      end

      visit account_show_order_path(order.token)
      page.should have_content('iphone4')
      page.should have_content('psp')
      page.should have_content('60')

    end

    it "should can registe a new customer " do
      visit new_customer_registration_path
      click_on '注册'
      within '#login_name' do
        page.should have_content('不能为空')
      end
      within '#login_email' do
        page.should have_content('不能为空')
      end
      within '#login_password' do
        page.should have_content('不能为空')
      end

      fill_in 'customer[name]', with: '李卫辉'
      fill_in 'customer[email]', with: 'liwh88@gmail.com'
      fill_in 'customer[password]', with: '666666'
      fill_in 'customer[password_confirmation]', with: '666666'

      click_on '注册'

      current_path.should == '/account/index'
      click_link '查看地址簿(0)'
      page.should have_content('管理地址簿')
      find('#add_address').visible? == false
      click_link '增加新地址'
      find('#add_address').visible? == true
      fill_in 'customer_address[name]', with: '李卫辉'
      select '中国', form: 'customer_address[country_code]'
      select '广东省', form: 'customer_address[province]'
      select '深圳市', form: 'customer_address[city]'
      select '南山区', form: 'customer_address[district]'
      fill_in 'customer_address[address1]', with: '深港产学研基地'
      fill_in 'customer_address[phone]', with: '13751042627'
      fill_in 'customer_address[zip]', with: '444333'
      fill_in 'customer_address[company]', with: 'shopqi'
      click_on '保存'

      find('#add_address').visible? == false

      within '#address_tables' do
        has_content?('收货人: 李卫辉').should be_true
        has_content?('详细地址: 中国 广东省深圳市南山区深港产学研基地').should be_true
        has_content?('邮政编码: 444333').should be_true
        has_content?('电话号码: 13751042627').should be_true
        has_content?('公司: shopqi').should be_true
      end

      find('#edit_address_1').visible?.should be_false
      click_link '编辑'
      find('#edit_address_1').visible?.should be_true
      check 'customer_address_default_address'
      click_on '保存'
      find('#edit_address_1').visible?.should be_false
      page.should have_content('默认地址')

      page.execute_script("window.confirm = function(msg) { return true; }")
      click_link '删除'
      page.should_not have_content('详细地址')

    end
  end
end
