require 'spec_helper'

describe Consumption do

  let(:shop) { Factory(:user).shop }

  let(:consumption) { Factory(:consumption, shop: shop) }

  it "should init price" do
    consumption.price.should eql 298.0
    consumption.total_price.should eql 596.0
  end

end
