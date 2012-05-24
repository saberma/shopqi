#encoding: utf-8
require 'spec_helper'

describe Subscribe do

  let(:user){ Factory(:user) }
  let(:shop) { user.shop}

  context 'when subsribe associate with user ' do

    it "should save success" do
      subscribe = shop.subscribes.create user: user
      subscribe.user.id.should eql user.id
    end

  end

  context 'when subsribe type with email ' do

    it "should save success" do
      subscribe = shop.subscribes.create address: 'liwh87@gmail.com'
      subscribe.errors.should be_empty
      subscribe.address.should eql 'liwh87@gmail.com'
    end

    it "should save failure" do
      subscribe = shop.subscribes.create address: 'liwh87@'
      subscribe.errors.should_not be_empty
    end
  end

end
