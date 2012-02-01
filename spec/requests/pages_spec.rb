# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Pages", js: true do

  include_context 'login admin'

  describe "GET /admin/pages" do

    before(:each) { visit pages_path }

    it "works!" do
      click_on '新增页面'
      fill_in 'page[title]', with: 'welcome'
      click_on '保存'
      page.should have_content('welcome')

      click_on '修改'
      fill_in 'page[title]', with: 'new-welcome'
      click_on '保存'
      page.should have_content('new-welcome')

      select '显示', from: 'page_published'
      sleep 1 # 延时处理
      page.should have_content('修改成功!')

      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('new-welcome')
    end

    it "should show published state" do # 状态提示
      within '#pages tbody' do
        within(:xpath, ".//tr[1]/td[1]") do
          page.should have_content('关于我们')
          page.should have_no_css('.status-hidden') # 不显示'隐藏'提示
        end
        within(:xpath, ".//tr[2]/td[1]") do
          page.should have_content('欢迎')
          page.should have_no_css('.status-hidden') # 不显示'隐藏'提示
        end
      end
      shop.pages.each do |page| # 都改为隐藏状态
        page.update_attributes! published: false
      end
      visit pages_path
      within '#pages tbody' do
        within(:xpath, ".//tr[1]/td[1]") do
          page.should have_content('关于我们')
          page.should have_css('.status-hidden') # 显示'隐藏'提示
          find('.status-hidden').should have_content('隐藏')
        end
        within(:xpath, ".//tr[2]/td[1]") do
          page.should have_content('欢迎')
          page.should have_css('.status-hidden') # 显示'隐藏'提示
          find('.status-hidden').should have_content('隐藏')
        end
      end
    end

  end

end
