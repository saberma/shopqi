require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers

  let(:page) { Factory(:page) }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(Factory(:user_admin))
  end

  context '#create' do

    it "success" do
      expect do
        post :create, page: { title: 'Welcome', body_html: 'Hello'}
        response.should be_redirect
      end.should change(Page, :count).by(1)
    end

  end

end
