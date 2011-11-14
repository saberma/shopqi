# encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Theme::Themes", js: true do # 主题商店

  let(:theme) { Factory :theme_woodland_dark }

  let(:user_admin) {  Factory :user_admin }

  let(:shop) { user_admin.shop }

  before(:each) do
    theme
    Capybara::Server.manual_host = "themes.lvh.me"
  end

  after(:each) { Capybara::Server.manual_host = nil }

  describe "GET /theme" do # 主题详情

    before(:each) do
      visit "/themes/#{theme.handle}/styles/#{theme.style_handle}"
    end

    describe "show" do # 查看

      it "should be success", focus: true do
        within '#overview' do
          page.should have_content(theme.name)
          page.should have_content('ShopQi官方模板')
          page.should have_content('查看示例')
        end
        theme.update_attributes! shop: '' # 无示例
        visit "/themes/#{theme.handle}/styles/#{theme.style_handle}"
        within '#overview' do
          page.should have_no_content('查看示例')
        end
      end

      it "should show photos" do
        find('#screenshots .fancy-box').click
        find('#fancybox-wrap').visible?.should be_true
      end

    end

    describe "styles" do # 相关风格

      let(:theme_slate) { Factory :theme_woodland_slate }

      it "should not be index" do
        theme_slate
        find('#styles').text.should be_blank
      end

      it "should be index" do
        visit "/themes/#{theme_slate.handle}/styles/#{theme_slate.style_handle}"
        all('#styles li').size.should_not eql 0
      end

    end

    describe "others" do # 其他主题

      it "should be index" do
        all('#themes li').size.should_not eql 0
      end

    end

  end

  describe "GET /" do # 主题商店

    before(:each) { visit '' }

    it "should be index" do
      page.has_css?('#themes li').should be_true
    end

    describe "filter" do

      describe "color state" do

        it "should select color" do
          find('.first.color').click
          page.has_css?('#themes li').should be_true
        end

        it "should select color and pay" do
          find('.first.color').click
          click_on '收费'
          page.has_no_css?('#themes li').should be_true
        end

      end


      describe "pay state" do

        it "should be free" do
          click_on '免费'
          page.has_css?('#themes li').should be_true
        end

        it "should be paid" do
          click_on '收费'
          page.has_no_css?('#themes li').should be_true
        end

      end

    end

  end

  # 由于获取主题需要进行oauth2认证(独立进程)，暂时不进行测试

end
