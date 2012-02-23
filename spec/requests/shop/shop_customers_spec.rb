#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shop::Customers", js: true do

  include_context 'use shop'

  let(:iphone4) { Factory :iphone4, shop: shop }
  let(:iphone4_variant) { iphone4.variants.first }
  let(:customer_liwh) { Factory :customer_liwh, shop: shop }

  let(:psp) { Factory :psp, shop: shop }
  let(:psp_variant) { psp.variants.first }
  let(:payment) { Factory :payment, shop: shop }
  let(:order) {
    o = Factory.build :order_liwh, shop: shop, shipping_rate: '普通快递-10.0', payment_id: payment.id
    o.line_items.build [
      {product_variant: iphone4_variant, price: 10, quantity: 2},
      {product_variant: psp_variant, price: 20, quantity: 2},
    ]
    o.save
    o
  }

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
      page.should have_css('#customer_detail')
      within '#customer_detail' do
        has_content?('李卫辉').should be_true
        has_content?('广东省').should be_true
        has_content?('深圳市').should be_true
        has_content?('南山区').should be_true
        has_content?('查看地址簿(1)').should be_true
      end

      within '#customer_orders' do
        has_content?('#1001').should be_true
        has_content?('待支付').should be_true
        has_content?('未发货').should be_true
      end

      visit account_show_order_path(order.token)
      page.should have_content('iphone4')
      page.should have_content('psp')
      page.should have_content('60')
    end

    it "should can registe a new customer" do
      visit new_customer_registration_path
      within '#regist_new_customer' do # 商店顶端还有一个注册链接，避免冲突
        click_on '注册'
      end
      within '.errors' do
        page.should have_content('姓名 不能为空')
        page.should have_content('邮箱 不能为空')
        page.should have_content('密码 不能为空')
      end

      fill_in 'customer[name]', with: '李卫辉'
      fill_in 'customer[email]', with: 'liwh88@gmail.com'
      fill_in 'customer[password]', with: '666666'
      fill_in 'customer[password_confirmation]', with: '666666'

      within '#regist_new_customer' do
        click_on '注册'
      end

      current_path.should == '/account/index'
      click_link '查看地址簿(0)'
      page.should have_content('管理地址')
      find('#add_address').should_not be_visible
      click_link '增加新地址'
      find('#add_address').should be_visible
      within '#add_address' do
        fill_in 'address[name]', with: '李卫辉'
        select '中国', form: 'address[country_code]'
        select '广东省', form: 'address[province]'
        select '深圳市', form: 'address[city]'
        select '南山区', form: 'address[district]'
        fill_in 'address[address1]', with: '深港产学研基地'
        fill_in 'address[phone]', with: '13751042627'
        fill_in 'address[zip]', with: '518000'
        fill_in 'address[company]', with: 'shopqi'
        click_on '增加新地址'
      end

      find('#add_address').should_not be_visible

      within '#address_tables' do
        page.should have_content('收货人: 李卫辉')
        page.should have_content('详细地址: 中国 广东省深圳市南山区深港产学研基地')
        page.should have_content('邮政编码: 518000')
        page.should have_content('公司: shopqi')
      end

      find('#edit_address_1').should_not be_visible
      click_link '编辑'
      find('#edit_address_1').should be_visible
      check 'address[default_address]'
      click_on '更新地址'
      find('#edit_address_1').should_not be_visible
      page.should have_content('默认地址')

      page.execute_script("window.confirm = function(msg) { return true; }")
      click_link '删除'
      page.should_not have_content('详细地址')
    end
  end
end
