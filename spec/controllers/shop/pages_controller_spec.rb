#encoding: utf-8
require 'spec_helper'

describe Shop::PagesController do

  let(:shop) { Factory(:user_admin).shop }

  let(:page) { shop.pages.where(handle: 'about-us').first }

  before :each do
    request.host = "#{shop.permanent_domain}.shopqi.com"
  end

  it 'should be show' do
    get 'show', handle: page.handle
    response.should be_success
    response.body.should have_content('关于我们')
  end

end
