require 'spec_helper'

describe CustomersController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    sign_in(user)
  end

  it 'should be search' do
    get :search
    JSON(response.body).should_not be_empty
  end

end
