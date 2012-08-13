# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "CustomCollections" do

  describe "GET /admin/custom_collections" do

    include_context 'login admin'

    let(:iphone4) { Factory :iphone4, shop: shop }

    before { iphone4 }

    it "works!", js: true do
      visit custom_collections_path
      click_on '新增自定义集合'
      fill_in 'custom_collection[title]', with: 'high price'
      click_on '保存'
      page.should have_content('high price')

      click_on 'iphone4' # 加入商品
      within '#products' do # 已加入集合的商品列表
        page.should have_content('iphone4')
      end

      click_on '修改'
      fill_in 'custom_collection[title]', with: 'low price'
      click_on '保存'
      page.should have_content('low price')

      select '隐藏', from: 'custom_collection_published'
      page.should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('high price')
    end
  end
end
