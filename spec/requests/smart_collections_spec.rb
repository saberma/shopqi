# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "SmartCollections", js: true do

  include_context 'login admin'

  let(:iphone4) { FactoryGirl.create :iphone4, shop: shop }

  let(:smart_collection) { FactoryGirl.create :smart_collection_high_price, shop: shop }

  let(:psp) { Factory :psp, shop: shop }

  describe "GET /admin/smart_collections" do

    before { iphone4 }

    it "works!" do
      visit custom_collections_path
      click_on '新增智能集合'
      fill_in 'smart_collection[title]', with: 'high price'
      click_on '保存'
      page.should have_content('high price')

      click_on '修改'
      fill_in 'smart_collection[title]', with: 'low price'
      click_on '保存'
      page.should have_content('low price')

      select '隐藏', :from => 'smart_collection_published'
      page.should have_content('修改成功!')
    end

    it "should be destroy" do # 删除
      visit smart_collection_path(smart_collection)
      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('high price')
      page.should have_content('商品集合')
    end

  end

  describe "issues" do

    context '#465' do

      before do
        psp.destroy
        iphone4 # id 不为 1
        smart_collection # new(product_id: product) product_id 都会被置为 1；要使用 new(product_id: product.id)
      end

      it "should be view" do
        visit smart_collection_path(smart_collection)
        page.should have_content(smart_collection.title)
      end

    end

  end

end
