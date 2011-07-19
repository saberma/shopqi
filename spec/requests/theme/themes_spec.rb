# encoding: utf-8
require 'spec_helper'
require 'subdomain_capybara_server'

describe "Theme::Themes", js: true do # 主题商店

  let(:user_admin) {  Factory :user_admin }

  let(:shop) { user_admin.shop }

  before(:each) { Capybara::Server.manual_host = "themes.lvh.me" }

  after(:each) { Capybara::Server.manual_host = nil }

  describe "GET /" do # 主题商店

    it "should be index" do
      visit '/'
      has_css?('#themes li').should be_true

    end
    
  end

end
