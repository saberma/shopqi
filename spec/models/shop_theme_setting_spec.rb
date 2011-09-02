require 'spec_helper'

describe ShopThemeSetting do

  let(:shop) { Factory(:user).shop }

  before :each do
    shop.theme.switch Theme.find_by_name('Prettify')
  end

  it 'should get confit_settings' do
    shop.theme.settings.exists?(name: 'bg_image_y_position').should be_true
  end

end
