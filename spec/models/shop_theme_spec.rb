require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  describe ShopThemeSetting do

    it 'should parse select element' do
      shop.theme.config_settings.has_key?('bg_image_y_position').should be_true
    end

    it 'should parse checkbox element' do
      shop.theme.config_settings['use_bg_image'].should eql 'false'
    end

  end

end
