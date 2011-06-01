require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  it 'should get confit_settings' do
    # bg_image_y_position是select节点
    shop.theme.config_settings.has_key?('bg_image_y_position').should be_true
  end

end
