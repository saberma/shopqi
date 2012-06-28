require 'spec_helper'

describe Activity do

  let(:user){ Factory(:user)}

  let(:shop) { user.shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  context '#create' do

    it "should save" do
      activity = shop.activities.log iphone4, 'new', user
      activity.reload.user.should_not be_nil
    end

  end

end
