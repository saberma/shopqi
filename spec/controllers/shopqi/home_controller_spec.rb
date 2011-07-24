require 'spec_helper'

describe Shopqi::HomeController do

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

end
