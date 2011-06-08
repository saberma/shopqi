# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "LinkLists" do
  #do use  in integration tests(http://rdoc.info/github/plataformatec/devise/master/Devise/TestHelpers)
  #include Devise::TestHelpers

  describe "GET /admin/link_lists" do

    include_context 'login admin'

    it "should be index", :js => true do

      visit link_lists_path
      click_on '新增链接列表'
      fill_in 'link_list[title]', with: 'products'
      click_on '保存'
      find('#flashnotice').should have_content('新增成功!')

      within(:xpath, "//li[contains(@class, 'link-list')][3]") do
        click_on '新增链接'
        find_field('link[title]').visible?
        fill_in 'link[title]', with: 'shirt-1'
        fill_in 'link[subject]', with: '/shirt'
        click_on '保存'
        page.should have_content('shirt-1')
        page.should have_content('/shirt')

        click_on '修改链接列表'
        fill_in 'link_list[title]', with: 'new-products'
        fill_in 'title', with: 'new-shirt-1'
        fill_in 'subject', with: '/new-shirt'
        click_on '保存'
        page.should have_content('new-products')
        page.should have_content('new-shirt-1')
        page.should have_content('/new-shirt')

        page.execute_script("window.confirm = function(msg) { return true; }")
        click_on '修改链接列表'
        find('.delete').click
        click_on '保存'
        page.should_not have_content('new-shirt-1')
        click_on '删除链接列表'
      end
      page.should_not have_content('new-products')
    end

  end

end
