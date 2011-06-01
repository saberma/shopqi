require 'spec_helper'

describe ShopThemeSetting do

  let(:shop) { Factory(:user).shop }

  it 'should get confit_settings' do
    shop.theme.settings.exists?(name: :bg_image_y_position).should be_true
  end

end
