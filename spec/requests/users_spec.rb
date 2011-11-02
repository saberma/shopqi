#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Users" do
  describe "GET /admin/account" do
    include_context 'login admin'
    it "works", js:true do
      visit account_index_path
      click_on '新增用户'
      fill_in 'user[name]', with: 'testss'
      fill_in 'user[email]', with: 'testss@gmail.com'
      click_on '新增'
      page.should have_content('testss@gmail.com')
      page.should have_content('新增用户成功！')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should have_no_content('testss@gmail.com')

      click_on '修改'
      fill_in 'user[name]', with: 'liwhh'
      fill_in 'user[phone]', with: '13751042627'
      fill_in 'user[bio]', with: '软件部'
      click_on '保存'
      page.should have_content('修改成功!')

    end
  end
end
