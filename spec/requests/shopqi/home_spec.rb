# encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Shopqi::Home", js: true do

  include_context 'use shopqi host'

  describe "GET /" do # 首页

    it "should be show" do
      visit '/'
      has_content?('华丽的界面').should be_true
    end

  end

  describe "GET /faq" do # 常见问题

    it "should be show" do
      visit '/faq'
      has_content?('ShopQi能做什么?').should be_true
    end

  end

  describe "GET /tour" do # 特色演示

    before(:each) { visit '/tour'}

    it "should show introduction" do
      has_content?('您自己的商店外观').should be_true
    end

    it "should show store" do
      click_on '运行您的商店'
      has_content?('建立一个网上商店您需要很多的电子商务功能').should be_true
    end

    it "should show design" do
      click_on '定制主题外观'
      has_content?('外观设计很容易定制').should be_true
    end

    it "should show security" do
      click_on '托管服务 & 安全'
      has_content?('我们负责数据的保密和安全工作').should be_true
    end

    it "should show features" do
      click_on '特色列表'
      has_content?('ShopQi特色列表').should be_true
    end

  end

  describe "GET /signup" do # 价格方案

    it "should be show" do
      visit '/signup'
      has_content?('价格(元)').should be_true
    end

  end

end
