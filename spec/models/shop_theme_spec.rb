require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  let(:settings) { shop.theme.config_settings['presets']['default'] }

  before :each do
    shop.theme.switch Theme.find_by_name('Prettify')
  end

  it 'should be list' do
    list = shop.theme.list
    list.should_not be_empty
    ["assets", "config", "layout", "snippets", "templates"].each do |key|
      list.has_key?(key).should be_true
    end
  end

  describe ShopThemeSetting do

    it 'should parse select element' do
      settings['bg_image_y_position'].should eql 'top'
    end

    it 'should parse checkbox element' do
      settings['use_bg_image'].should eql 'false'
    end

  end

end
