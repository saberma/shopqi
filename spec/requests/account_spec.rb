#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'
require 'resque_spec/scheduler'

describe "Account" do

  context '#destroy' do #删除商店
    describe "GET /admin/account" do
      include_context 'login admin'

      it "works", js: true do
        visit account_index_path
        click_on '删除我的帐户(我知道这是无法恢复的)'
        page.should have_content('关闭商店')

        page.execute_script("window.confirm = function(msg) { return true; }")
        select '很难使用', form: "cancel_reason_selection"
        fill_in "cancel_reason[detailed]", with: "测试删除"
        click_on "关闭商店"

        page.should have_content('成功删除')
        DeleteShop.should have_scheduled(Shop.first.id)

        visit account_index_path
        page.should have_content('该商店不存在')

      end
    end
  end

  context '#update user permission' do #在账户页面更改用户权限
    describe "change the user permission" do
      include_context 'login admin'
      it "should can update the permission",js: true,f: true do
        visit account_index_path
        click_on '新增用户'
        fill_in 'user[name]', with: 'liwh'
        fill_in 'user[email]', with: 'liwh88@gmail.com'
        click_on '新增'
        page.should have_content('新增用户成功！')
        u = User.find_by_email('liwh88@gmail.com')

        click_link 'liwh'
        within(:xpath,"//table[@class='standard-table']/tbody/tr[4]") do
          page.should have_content('拥有所有权限')
          page.should have_content('选择权限')
          choose "user_#{u.id}_limited_access"
          page.should have_content('订单')
          uncheck "user_#{u.id}_resource_3"
          click_button '保存'
        end

        page.should have_content('更新成功')

        click_link '退出登录'
        visit new_user_session_path
        fill_in 'user[email]', with: 'liwh88@gmail.com'
        fill_in 'user[password]', with: '666666'

        click_on '登录'
        visit '/admin/orders'
        page.should have_content('没有权限')
      end
    end
  end

end
