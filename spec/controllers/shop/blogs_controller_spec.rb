#encoding: utf-8
require 'spec_helper'

describe Shop::BlogsController do

  let(:shop) do
    model = Factory(:user_admin).shop
    model.update_attributes password_enabled: false
    model
  end

  let(:blog) { shop.blogs.where(handle: :news).first }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    shop.theme.switch Theme.find_by_handle('woodland')
  end

  it 'should be show' do
    get 'show', handle: blog.handle
    response.should be_success
    response.body.should have_content('最新动态')
  end


end
