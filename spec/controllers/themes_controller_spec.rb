require 'spec_helper'

describe ThemesController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    sign_in(user)
  end

  it 'should be update' do
    put :update
    response.should be_success
  end

end
