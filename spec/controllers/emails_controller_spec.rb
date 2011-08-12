#encoding: utf-8
require 'spec_helper'

describe EmailsController do
  include Devise::TestHelpers

  let(:user){ Factory(:user)}
  let(:shop){ user.shop}
  let(:subscribes){ shop.subscribes}

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  context '#follow' do
    it "should create subscribe success" do
      expect do
        xhr :post, :follow,subscribe: "email", address: "ee@gmail.com"
      end.should change(Subscribe, :count).by(1)
    end
  end

  context '#unfollow' do
    it "should remove a subscribe " do
      expect do
        xhr :delete, :unfollow, id: subscribes.first.id
      end.should change(Subscribe,:count).by(-1)
    end
  end

end
