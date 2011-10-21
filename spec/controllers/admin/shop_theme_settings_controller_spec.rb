require 'spec_helper'

describe Admin::ShopThemeSettingsController do
  include Devise::TestHelpers

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:user) { Factory(:user) }

  let(:shop) { user.shop }

  before :each do
    request.host = "#{shop.primary_domain.host}"
    shop.themes.install theme_dark
    sign_in(user)
  end

  it 'should be update' do
    put :update, id: shop.theme.id, load_preset: 'origin', save_preset: {}, settings: {}
    response.should be_success
  end

end
