# encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Shop::Shops", js:true do

  let(:theme) { Factory :theme_woodland_dark }

  #let(:user_admin) {  with_resque { Factory :user_admin } }
  let(:user_admin) {  Factory :user_admin }

  let(:shop) do
    model = user_admin.shop
    model.update_attributes password_enabled: false
    model.themes.install theme
    model
  end

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

  let(:payment) { Factory :payment, shop: shop }

  before(:each) { Capybara::Server.manual_host = shop.primary_domain.host }

  after(:each) { Capybara::Server.manual_host = nil }

  describe "GET /products" do # 首页

    it "should show product" do
      payment
      product = iphone4
      variant = product.variants.first
      visit '/'
      click_on product.title
      page.should have_content(product.body_html)
      click_on '加入购物车'
      # 更新数量
      fill_in "updates_#{variant.id}", with: '2'
      find('form').click # 输入项失焦点触发更新事件
      find("#updates_#{variant.id}")[:value].should eql '2'
      click_on '结算'
      #收货人
      fill_in 'order[email]', with: 'mahb45@gmail.com'
      fill_in 'order[shipping_address_attributes][name]', with: '马海波'
      select '广东省', form: 'order[shipping_address_attributes][province]'
      select '深圳市', form: 'order[shipping_address_attributes][city]'
      select '南山区', form: 'order[shipping_address_attributes][district]'
      fill_in 'order[shipping_address_attributes][address1]', with: '科技园'
      fill_in 'order[shipping_address_attributes][phone]', with: '13928458888'
      click_on '去到下一步'
      #选择支付方式
      page.should have_content(product.title)
      choose '邮局汇款'
      click_on '购买'
      page.should have_content("您的订单号为： #1001")
    end

  end

  # 首页
  describe "GET /" do

    it "should list products" do
      iphone4
      visit '/'
      page.should have_content(iphone4.title)
    end

    it "should redirect to passowrd" do  # 密码保护
      shop.update_attributes password_enabled: true, password_message: '正在维护中...'
      visit '/'
      page.should have_content(shop.password_message)
      fill_in 'password', with: shop.password
      click_on '提交'
      page.should have_content('关于我们')
    end

    it "should redirect to unavailable page" do  # 密码保护
      shop.update_attributes deadline: Date.new(2001,01,01)
      visit '/'
      page.should have_content "过期"
    end

    describe 'customer' do # 顾客

      it "should show register link" do  # 注册
        visit '/'
        page.should have_content "注册"
      end

    end

  end

  # 查询(需要启动全文检索服务) RAILS_ENV=test bundle exec rake sunspot:solr:run
  describe "GET /search", searchable: true do

    before(:each) do
      iphone4
      visit '/'
      click_on '查询'
    end

    it "should list blog article" do
      with_resque do
        blog = shop.blogs.where(handle: 'news').first
        article = blog.articles.create title: '如何选购iphone'
      end
      click_on '查询'
      within '#search' do
        fill_in 'q', with: '选购'
        click_on '查询'
        page.should have_content('如何选购iphone')
      end
    end

    it "should list products" do
      within '#search' do
        fill_in 'q', with: iphone4.title
        click_on '查询'
        page.should have_content(iphone4.title)
      end
    end

    it "should list page" do
      within '#search' do
        fill_in 'q', with: '关于'
        click_on '查询'
        page.should have_content('关于我们')
      end
    end

    it "should paginate the seach results", f:true  do

      with_resque do
        1.upto(11).each do |n|
          shop.products.create(title: "示例商品#{n}",vendor: '苹果', product_type: '电子产品')
        end
      end

      within '#search' do
        fill_in 'q', with: '示例'
        click_on '查询'
        page.should_not have_content('示例商品11')
        page.should have_link('1') # 页码1
        page.should have_link('2') # 页码2
        click_link '2'
        page.should have_content('示例商品11')
      end

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
      iphone4
      visit '/'
      click_on '商品列表'
      page.should have_content(iphone4.title)
    end
  end

end
