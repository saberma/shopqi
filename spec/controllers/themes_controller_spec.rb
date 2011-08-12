require 'spec_helper'

describe ThemesController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should be update' do
    put :update, theme: { load_preset: 'origin', save_preset: {}, settings: {}}
    response.should be_success
  end

end
