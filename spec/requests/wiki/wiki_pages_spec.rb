#encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Wiki::WikiPages", js: true do

  let(:admin_user){ create :admin_user}

  before(:each) { Capybara::Server.manual_host = "wiki.lvh.me" }

  after(:each) {
    Capybara::Server.manual_host = nil
    FileUtils.remove_dir WikiPage.path  #测试完，删除目录
  }

  describe "GET /" do

    it "should show the proper link ", f: true do
      admin_user

      #测试显示链接(未登陆)
      visit '/'
      has_link?('wiki首页').should be_true
      has_no_link?('编辑').should be_true
      has_no_link?('删除').should be_true
      has_no_link?('历史').should be_true
      has_link?('页面列表').should be_true
      has_link?('登录').should be_true

      #登陆
      visit new_admin_user_session_path
      fill_in 'admin_user[email]'   , with: "admin@shopqi.com"
      fill_in 'admin_user[password]', with: "666666"
      click_on 'Login'

      has_link?('新增').should be_true

      #测试新增
      visit new_wiki_page_path
      fill_in 'name'   , with: 'home'
      fill_in 'chinese_name'   , with: '首页'
      fill_in 'content', with: "h2. 内容"
      fill_in 'message', with: '新增首页'
      select  'textile', from: 'format'
      click_on '保存'

      current_path.should == "/home"
      within("h2") do
        has_content?("内容").should be_true
      end

      #测试编辑
      click_link '编辑'
      within("textarea#content") do
        has_content?("h2.").should be_true
      end
      fill_in 'content', with: 'h3. 内容'
      click_on '保存'
      within("h3") do
        has_content?("内容").should be_true
      end

      #测试页面列表
      visit new_wiki_page_path
      fill_in 'name'   , with: 'side'
      fill_in 'content', with: "h2. 内容"
      fill_in 'message', with: '新增首页'
      select  'textile', from: 'format'
      click_on '保存'
      click_link '页面列表'
      has_link?('side').should be_true
      has_link?('首页').should be_true #此处测测中文名

      #测试回退
      visit "/home"
      click_link '历史'
      within(:xpath, "//table/tbody/tr[1]") do
        check "versions[]"
      end
      within(:xpath, "//table/tbody/tr[2]") do
        check "versions[]"
      end

      click_link '比较'
      click_on '回退'
      within("h2") do
        has_content?("内容").should be_true
      end

      #测试预览
      visit "/home"
      click_link '编辑'
      find_link('预览').click
      has_content?("内容").should be_true

    end
  end
end
