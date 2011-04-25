require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers

  let(:page) { Factory(:page) }

  before :each do
    sign_in(Factory(:user_admin))
  end

  context '#create' do

    it "success" do
      expect do
        post :create, page: { title: 'Welcome', content: 'Hello'}
        response.should be_success
        assign[:page].shop.should_not be_nil
      end.should change(Page, :count).by(1)
    end

  end

end
