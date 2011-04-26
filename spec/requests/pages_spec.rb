# encoding: utf-8
require 'spec_helper'

describe "Pages" do
  describe "GET /admin/pages" do

    let(:user_admin) { Factory :user_admin }

    it "works!", :js => true do
      visit new_user_session_path
      fill_in 'user[email]', with: user_admin.email
      fill_in 'user[password]', with: user_admin.password
      click_on 'log in'

      visit pages_path
      click_on '新增页面'
      fill_in 'page[title]', with: 'welcome'
      click_on '保存'
      page.should have_content('welcome')
      Page.all.size.should eql 1

      click_on '修改'
      fill_in 'page[title]', with: 'new-welcome'
      click_on '保存'
      page.should have_content('new-welcome')

      select '显示', :from => 'page_published'
      find('#flashnotice').should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('new-welcome')
    end
  end
end
