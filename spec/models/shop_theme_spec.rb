require 'spec_helper'

describe ShopTheme do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  describe ShopThemeSetting do

    describe 'settings.html' do

      it 'should be transform' do
        transform = theme.settings.transform
        transform.should include 'asset-image'
        transform.should include 'theme[settings]'
        transform.should include 'hidden' # 复选框未选中时的值
        transform.should include 'Monospace' # 字体选项
      end

      describe 'preset' do #保存更新预设

        it 'should be save' do
          theme.settings.save 'newest', data
          settings = theme.settings.as_json
          settings['presets']['newest'].should_not be_nil
          settings['presets']['newest']['use_logo_image'].should be_false
          settings['current'].should eql 'newest'
          theme.settings.where(name: 'use_logo_image').first.value.should eql 'f'
        end

        it 'should be destroy' do
          theme.settings.destroy_preset 'original'
          settings = theme.settings.as_json
          settings['current'].class.should eql Hash
          theme.settings.where(name: 'use_logo_image').first.value.should eql 't'
        end

        it 'should be save custom' do
          theme.settings.save '', data
          settings = theme.settings.as_json
          settings['current'].class.should eql Hash
        end

        it 'should be update' do
          theme.settings.save 'default', data
          settings = theme.settings.as_json
          settings['presets']['default'].should_not be_nil
          settings['presets']['default']['use_logo_image'].should be_false
          settings['current'].should eql 'default'
        end

      end

    end

    it 'should parse select element' do
      theme.switch Theme.find_by_handle('Prettify')
      settings = theme.config_settings['presets']['default']
      settings['bg_image_y_position'].should eql 'top'
    end

    it 'should parse checkbox element' do
      settings = theme.config_settings['presets']['original']
      settings['use_logo_image'].should eql true
    end

  end

  def data
    {use_logo_image:"0", logo_color:"#ffffff", use_logobackground_image:"1", use_feature_image:"1", use_bannerbackground_image:"1", use_bannerurl_image:"danielweinand.com", use_header_image:"1", header_color:"#ffffff", body_background:"1", background_color:"#000000", text_color:"#000000", heading_color:"#000000", link_color:"#970000", linkhover_color:"#680000", mainnav_color:"#ffffff", mainnavhover_color:"#ffffff", mainnavline_color:"#ffffff", subnav_color:"#937c72", subnavhover_color:"#f1bda9", footertext_color:"#d5c4bf", footerlink_color:"#915c4f", footerline_color:"#674a43", checkoutheader_color:"#767676", header_font:"'Courier New', Courier, monospace", regular_font:"Helvetica, Arial, sans-serif", cart_graphic:"1", border_color:"#b7b7c2", border_grunge:"1", productborder_color:"#f2f2f2", productborderhover_color:"#ffffff", use_footer_image:"1", bgfooter_color:"#000000", customer_layout:"theme"}
  end

end
