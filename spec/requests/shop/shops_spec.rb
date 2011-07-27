# encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Shop::Shops", js:true do

  #let(:user_admin) {  with_resque { Factory :user_admin } }
  let(:user_admin) {  Factory :user_admin }

  let(:shop) { user_admin.shop }

  before(:each) { Capybara::Server.manual_host = "#{shop.primary_domain.url}" }

  after(:each) { Capybara::Server.manual_host = nil }

  describe "GET /products" do # 首页

    it "should show product" do
      product = shop.products.where(handle: 'example-1').first
      variant = product.variants.first
      visit '/'
      click_on product.title
      page.should have_content('这是一个商品')
      click_on 'Add to cart'
      # 更新数量
      within('#checkout') do
        fill_in "updates_#{variant.id}", with: '2'
      end
      click_on 'Update'
      find("#updates_#{variant.id}")[:value].should eql '2'
      click_on 'Checkout'
      #收货人
      fill_in 'order[email]', with: 'mahb45@gmail.com'
      fill_in 'order[billing_address_attributes][name]', with: '马海波'
      select '广东省', form: 'order[billing_address_attributes][province]'
      select '深圳市', form: 'order[billing_address_attributes][city]'
      select '南山区', form: 'order[billing_address_attributes][district]'
      fill_in 'order[billing_address_attributes][address1]', with: '科技园'
      fill_in 'order[billing_address_attributes][phone]', with: '13928458888'
      click_on '去到下一步'
      #选择支付方式
      page.should have_content(product.title)
      click_on '购买'
      page.should have_content("您的订单号为： #1001")
    end

  end

  # 首页
  describe "GET /" do

    it "should list products" do
      visit '/'
      page.should have_content('示例商品1')
    end

  end

  # 查询
  describe "GET /search" do

    before(:each) do
      ThinkingSphinx::Test.start
      visit '/'
      click_on '查询'
    end

    after(:each) do
      ThinkingSphinx::Test.stop
    end

    it "should list blog article" do
      blog = shop.blogs.where(handle: 'latest-news').first
      article = blog.articles.create title: '如何选购iphone'
      ThinkingSphinx::Test.index 'article_delta'
      click_on '查询'
      fill_in 'q', with: '选购'
      click_on 'Search'
      page.should have_content(article.title)
    end

    it "should list products" do
      fill_in 'q', with: '示例'
      click_on 'Search'
      page.should have_content('示例商品1')
    end

    it "should list page" do
      fill_in 'q', with: '关于'
      click_on 'Search'
      page.should have_content('关于我们')
    end

  end

  # 关于我们
  describe "GET /pages" do

    it "should list products!" do
      visit '/'
      click_on '关于我们'
      page.should have_content('介绍您的公司')
    end

  end

  # 商品列表
  describe "GET /collections/all" do

    it "should list products!" do
      visit '/'
      click_on '商品列表'
      page.should have_content('示例商品6')
    end
  end

end
