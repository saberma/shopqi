require 'spec_helper'

describe ShopThemeSettingsController do
  include Devise::TestHelpers

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    sign_in(user)
  end

  it 'should be update' do
    put :update, id: shop.theme.id, load_preset: 'origin', save_preset: {}, settings: {}
    response.should be_success
  end

end
