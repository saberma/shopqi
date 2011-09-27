require 'spec_helper'

describe Admin::CustomersController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  let(:customer) { Factory(:customer_saberma, shop: shop) }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should be search' do
    customer
    get :search
    JSON(response.body).should_not be_empty
  end

end
