require 'spec_helper'

describe ShopController do

  let(:shop) { Factory(:user_admin).shop }

  let(:iphone4) { Factory.build(:iphone4) }

  before :each do
    request.host = "#{shop.permanent_domain}.shopqi.com"
  end

  it 'should be show' do
    get :show
    response.body.should eql 'success'
  end

end
