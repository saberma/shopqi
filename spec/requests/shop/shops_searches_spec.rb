# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shop::Searches", js:true do

  include_context 'use shop'

  let(:frontpage_collection) { shop.custom_collections.where(handle: 'frontpage').first }

  let(:iphone4) { Factory :iphone4, shop: shop, collections: [frontpage_collection] }

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

    it "should paginate the seach results" do

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

end
