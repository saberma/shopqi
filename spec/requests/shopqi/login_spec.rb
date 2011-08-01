# encoding: utf-8
require 'spec_helper'

describe "Shopqi::Login", js: true do

  let(:user_admin) {  Factory :user_admin }

  let(:shop) { user_admin.shop }

  describe "GET /login" do

    before(:each) do
      Capybara.server_port = 31337 # 指定port
      Setting.stub!(:store_host_with_port).and_return("#{Setting.store_host}:#{Capybara.server_port}")
      visit '/login'
    end

    it "should show message" do
      fill_in '商店Web地址', with: shop.primary_domain.subdomain
      click_on 'log in'
      has_content?('邮箱或密码错误').should be_true
    end

    it "should be login" do
      fill_in '商店Web地址', with: shop.primary_domain.subdomain
      fill_in 'Email'      , with: 'admin@shopqi.com'
      fill_in '密码'       , with: '666666'
      click_on 'log in'
      has_content?('最新的活动记录').should be_true
    end

  end

end
