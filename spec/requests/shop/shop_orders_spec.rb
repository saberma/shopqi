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

  ##### 结算 #####
  describe "Cart" do

    it 'should show order address page' do # issues#248
      visit "/cart"
      click_on '结算'
      page.should have_content('填写购物信息') # 显示结算页面
    end

    it 'should be keep after customer sign in' do # issues#260
      visit '/'
      page.should have_content('购物车 (1)')
      customer_saberma # 已有顾客
      visit "/account/login"
      fill_in 'customer[email]'                , with: 'mahb45@gmail.com'
      fill_in 'customer[password]'             , with: '666666'
      within '#customer' do # 商店顶端还有一个登录链接，避免冲突
        click_on '登录'
      end
      page.should have_content('购物车 (1)') # 购物车商品仍然保留
    end

  end

  ##### 顾客登录 #####
  describe "Customers" do

    before(:each) do
      shop.update_attributes customer_accounts: :required # 要求用户注册
    end

    #it 'should be sign up' do # 暂时没有注册流程，提交订单后才有注册
    #  visit "/cart"
    #  click_on '结算'
    #  page.should have_content('顾客登录') # 跳转至登录页面
    #  click_on '注册账号'
    #  fill_in 'customer[name]'                 , with: '马海波'
    #  fill_in 'customer[email]'                , with: 'mahb45@gmail.com'
    #  fill_in 'customer[password]'             , with: '666666'
    #  fill_in 'customer[password_confirmation]', with: '666666'
    #  click_on '注册'
    #  page.should have_content('填写购物信息') # 跳转回结算页面
    #end

    it 'should be sign in' do
      customer_saberma # 已有顾客
      visit "/cart"
      click_on '结算'
      page.should have_content('顾客登录') # 跳转至登录页面
      fill_in 'customer[email]'                , with: 'mahb45@gmail.com'
      fill_in 'customer[password]'             , with: '666666'
      within '#customer' do # 商店顶端还有一个登录链接，避免冲突
        click_on '登录'
      end
      page.should have_content('填写购物信息') # 跳转回结算页面
      page.should have_content('mahb45@gmail.com') # 回显已经登录的顾客信息
      within '#cost' do
        page.should have_content('3000.0') # 计算金额
      end
    end

  end

  ##### 优惠码 #####
  describe "Discount" do

    let(:payment) { Factory :payment, shop: shop }

    let(:discount) { shop.discounts.create code: 'COUPON123', value: 10, usage_limit: 20 }

    context 'exist discount' do # 商店有优惠码

      before do
        payment
        discount
      end

      it 'should show the discount form' do # 要显示优惠码输入框
        visit "/cart"
        click_on '结算'
        fill_in 'discount[code]', with: discount.code
        click_on '提交'
        find('#discount-detail').should have_content("您正使用优惠码 #{discount.code} 节省了 10 元。")
        find('#cost').should have_content("¥#{(iphone4_variant.price - discount.value).to_i}")
        #收货人
        fill_in 'order[email]', with: 'mahb45@gmail.com'
        fill_in 'order[shipping_address_attributes][name]', with: '马海波'
        select '广东省', form: 'order[shipping_address_attributes][province]'
        select '深圳市', form: 'order[shipping_address_attributes][city]'
        select '南山区', form: 'order[shipping_address_attributes][district]'
        fill_in 'order[shipping_address_attributes][address1]', with: '311'
        fill_in 'order[shipping_address_attributes][phone]', with: '13928458888'
        choose '普通快递-¥10' #选择配送方式
        choose '邮局汇款' #选择支付方式
        click_on '提交订单'
        page.should have_content("您的订单号为： #1001")
        visit new_user_session_path # 登录后台查看订单
        fill_in 'user[email]', with: user_admin.email
        fill_in 'user[password]', with: user_admin.password
        click_on '登录'
        visit orders_path
        click_on '#1001'
        within '#discount' do # 显示优惠码和优惠金额
          find(:xpath, ".//td[2]").should have_content(discount.code)
          find(:xpath, ".//td[3]").should have_content("-10")
        end
        find('#price-summary').should have_content((iphone4_variant.price - discount.value).to_i) # 小计要减掉优惠金额
      end

    end

    context 'do not exist discount' do # 没有优惠码

      it 'should not show the discount form' do # 不显示优惠码输入框
        visit "/cart"
        click_on '结算'
        page.should_not have_content('如果您有优惠码，请在此处输入')
      end
    end

  end

end
