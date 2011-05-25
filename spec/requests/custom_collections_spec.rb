# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "CustomCollections" do
  describe "GET /admin/custom_collections" do
    include_context 'login admin'

    it "works!", js: true do

      visit custom_collections_path
      click_on '新增自定义集合'
      fill_in 'custom_collection[title]', with: 'high price'
      click_on '保存'
      page.should have_content('high price')
      CustomCollection.all.size.should eql 1

      click_on '修改'
      fill_in 'custom_collection[title]', with: 'low price'
      click_on '保存'
      page.should have_content('low price')

      select '隐藏', from: 'custom_collection_published'
      find('#flashnotice').should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('high price')

    end
  end
end
