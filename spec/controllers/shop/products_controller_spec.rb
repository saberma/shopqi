# encoding: utf-8
require 'spec_helper'

describe Shop::ProductsController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end

  let(:iphone4) { Factory(:iphone4, shop: shop) }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  it 'should be show' do
    get 'show', handle: iphone4.handle
    response.should be_success
    response.body.should have_content('iphone')
  end

  context 'js' do

    it 'should be get', focus: true do # 获取product json
      get 'show', handle: iphone4.handle, format: :js
      response.should be_success
      json = JSON(response.body)
      json.should_not be_empty
      %w(id handle title available).each do |attr|
        json[attr].should eql iphone4.send(attr)
      end
      json['options'].should eql ['标题']
      json['variants'].should_not be_empty
    end

  end

  it "should not create new product" do

  end

  describe 'error' do

    it "should handle not found" do
      get 'show', handle: 'no-exists-handle'
      response.status.should eql 404
    end

  end

end
