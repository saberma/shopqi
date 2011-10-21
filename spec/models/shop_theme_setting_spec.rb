require 'spec_helper'

describe ShopThemeSetting do

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  before :each do
    shop.themes.install theme_dark
  end

  it 'should get confit_settings' do
    shop.theme.settings.exists?(name: 'use_logo_image').should be_true
  end

end
