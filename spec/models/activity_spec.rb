require 'spec_helper'

describe Activity do
  let(:user){ Factory(:user)}
  context '#create' do
    it "should save" do
      Activity.create operate: 'new',class_name: 'product', user: user, shop: user.try(:shop)
    end
  end
end
