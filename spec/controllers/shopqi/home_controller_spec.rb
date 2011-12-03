#encoding: utf-8
require 'spec_helper'

describe Shopqi::HomeController do

  before { request.host = "www.#{Setting.host}" }

  describe 'homepage' do

    it "should be show" do
      get :page
      response.should be_success
    end

  end

  describe 'faq' do

    it "should be show" do
      get :faq
      response.should be_success
    end

  end

  describe 'tour' do

    it "should show introduction" do
      get :tour
      response.should be_success
    end

    it "should show store" do
      get :store
      response.should be_success
    end

    it "should show design" do
      get :design
      response.should be_success
    end

    it "should show security" do
      get :security
      response.should be_success
    end

    it "should show features" do
      get :features
      response.should be_success
    end

  end

  describe 'no shop' do

    before { request.host = "http://aaa.lvh.me:4000" }

    it "should show info" do
      get :no_shop
      response.status.should eql 404
      response.should render_template("shared/no_shop")
    end

    context '/robots.txt' do

      it "should show info" do
        get :no_shop, format: :text
        response.status.should eql 404
        response.should render_template("shared/no_shop")
      end

    end

  end

  describe 'subdomain' do

    it "should use www subdomain" do # issues#291
      request.host = "lvh.me"
      get :page
      response.status.should eql 301
      response.should be_redirect
    end

  end

  describe 'robots' do

    it "should be show" do
      get :robots
      response.should be_success
      response.body.should include 'Sitemap'
    end

  end

end
