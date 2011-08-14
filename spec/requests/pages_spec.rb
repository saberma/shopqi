# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Pages" do

  describe "GET /admin/pages" do

    include_context 'login admin'

    it "works!", js: true do

      visit pages_path
      click_on '新增页面'
      fill_in 'page[title]', with: 'welcome'
      click_on '保存'
      page.should have_content('welcome')

      click_on '修改'
      fill_in 'page[title]', with: 'new-welcome'
      click_on '保存'
      page.should have_content('new-welcome')

      select '显示', :from => 'page_published'
      page.should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('new-welcome')
    end

  end

end
