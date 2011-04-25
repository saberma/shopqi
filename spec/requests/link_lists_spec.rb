# encoding: utf-8
require 'spec_helper'

describe "LinkLists" do
  #do use  in integration tests(http://rdoc.info/github/plataformatec/devise/master/Devise/TestHelpers)
  #include Devise::TestHelpers

  describe "GET /admin/link_lists" do

    let(:user_admin) { Factory :user_admin }

    it "should be index", :js => true do
      visit new_user_session_path
      fill_in 'user[email]', with: user_admin.email
      fill_in 'user[password]', with: user_admin.password
      click_on 'log in'

      visit link_lists_path
      click_on '新增链接列表'
      fill_in 'link_list[title]', with: 'products'
      click_on '保存'
      find('#flashnotice').should have_content('新增成功!')
      LinkList.all.size.should eql 1

      within '.links' do
        click_on '新增链接'
        find_field('link[title]').visible?
        fill_in 'link[title]', with: 'shirt-1'
        fill_in 'link[subject]', with: '/shirt'
        click_on '保存'
        page.should have_content('shirt-1')
        page.should have_content('/shirt')
        Link.all.size.should eql 1

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
      end

      click_on '删除链接列表'
      page.should_not have_content('new-products')
    end
  end
end
