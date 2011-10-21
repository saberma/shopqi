#encoding: utf-8
require 'spec_helper'

describe Shop::PagesController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) do
    model = Factory(:user_admin).shop
    model.themes.install theme
    model.update_attributes password_enabled: false
    model
  end

  let(:page) { shop.pages.where(handle: 'about-us').first }

  before :each do
    request.host = "#{shop.primary_domain.host}"
  end

  it 'should be show' do
    get 'show', handle: page.handle
    response.should be_success
    response.body.should have_content('关于我们')
  end

end
