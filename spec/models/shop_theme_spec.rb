require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:settings) { theme.config_settings['presets']['default'] }

  before :each do
    theme.switch Theme.find_by_name('Prettify')
  end

  describe ShopThemeSetting do

    describe 'settings.html' do

      it 'should be transform' do
        theme.settings_transform.should include 'asset-image'
      end

    end

    it 'should parse select element' do
      settings['bg_image_y_position'].should eql 'top'
    end

    it 'should parse checkbox element' do
      settings['use_bg_image'].should eql 'false'
    end

  end

end
