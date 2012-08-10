# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "SmartCollections" do

  describe "GET /admin/smart_collections" do

    include_context 'login admin'

    let(:iphone4) { Factory :iphone4, shop: shop }

    before { iphone4 }

    it "works!", js: true do
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

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('high price')
    end

  end

end
