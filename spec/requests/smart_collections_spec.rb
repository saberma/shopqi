# encoding: utf-8
require 'spec_helper'

describe "SmartCollections" do
  describe "GET /admin/smart_collections" do

    let(:user_admin) { Factory :user_admin }

    it "works!", js: true do
      visit new_user_session_path
      fill_in 'user[email]', with: user_admin.email
      fill_in 'user[password]', with: user_admin.password
      click_on 'log in'

      visit smart_collections_path
      click_on '新增智能集合'
      fill_in 'smart_collection[title]', with: 'high price'
      click_on '保存'
      page.should have_content('high price')
      SmartCollection.all.size.should eql 1

      click_on '修改'
      fill_in 'smart_collection[title]', with: 'low price'
      click_on '保存'
      page.should have_content('low price')

      select '隐藏', :from => 'smart_collection_published'
      find('#flashnotice').should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('high price')
    end

  end
end
