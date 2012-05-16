# encoding: utf-8
require 'spec_helper'

describe ShopTheme do

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:theme_slate) { Factory :theme_woodland_slate }

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  describe 'Theme' do

    it 'should be install' do
      expect do
        shop.themes.install theme_dark
      end.should change(ShopTheme, :count).by(1)
    end

    context '#duplicate' do

      context 'a system theme' do

        it 'should be success' do
          shop.themes.install theme_dark
          theme
          expect do
            duplicate_theme = theme.duplicate
            duplicate_theme.name.should eql "副本 #{theme.name}"
          end.should change(ShopTheme, :count).by(1)
        end

      end

      context 'a user theme' do # 用户自行上传

        let(:name) { 'user_theme' }

        let(:user_theme) { shop.themes.create name: name, role: 'wait' }

        before do
          zip_path = Rails.root.join 'spec', 'factories', 'data', 'themes', 'woodland.zip'
          with_resque do
            Resque.enqueue(ThemeExtracter, shop.id, user_theme.id, zip_path)
          end
        end

        it 'should be success' do
          duplicate_theme = user_theme.duplicate
          duplicate_theme.name.should eql "副本 #{name}"
          File.exists?(duplicate_theme.path).should be_true
        end

      end

    end

  end

  describe ShopThemeSetting do

    before(:each) do
      shop.themes.install theme_dark
    end

    describe 'settings.html' do

      it 'should be transform' do
        transform = theme.settings.transform
        transform.should include 'asset-image'
        transform.should include 'settings'
        transform.should include 'Monospace' # 字体选项
      end

      describe 'class', focus: true do # 根据class的值转换为实际的链接列表选项等

        before(:each) do
          settings_html_path = Rails.root.join("spec/factories/data/themes/settings/with_class.html")
          Asset.create(theme, 'config/settings.html', nil, File.read(settings_html_path))
        end

        let(:transform) { theme.settings.transform }

        it 'should list collections' do
          transform.should include '首页商品'
        end

        it 'should list blogs' do
          transform.should include '最新动态'
        end

        it 'should list pages' do
          transform.should include '关于我们'
          transform.should include '欢迎'
        end

        it 'should list linklists' do
          transform.should include '主菜单'
          transform.should include '页脚'
        end

        it 'should list snippets' do
          transform.should_not include 'recent-posts.liquid'
          transform.should_not include 'sidebar-navigation.liquid'
          transform.should include 'recent-posts'
          transform.should include 'sidebar-navigation'
        end

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
          %w(黑桤木 石板 桦木).each do |preset|
            theme.settings.destroy_preset preset
          end
          settings = theme.settings.as_json
          settings['current'].class.should eql Hash
          theme.settings.where(name: 'use_logo_image').first.value.should eql 'f'
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
      shop.themes.install theme_slate
      theme = shop.theme
      settings = theme.config_settings['presets']['桦木']
      settings['bg_image'].should eql 'bg-lightwood.jpg'
    end

    it 'should parse checkbox element' do
      settings = theme.config_settings['presets']['桦木']
      settings['use_banner_image'].should eql true
    end

  end

  describe 'link path' do

    # capistrano部署时会将current 链接到 release_path 目录，但FileUtils.ln_s不能指向release_path，旧有release_path会随时被删除
    it 'should use source path, instead of linked path' do
      data_path = "/tmp/deploy/#{DateTime.now.to_i}/shared/data" # shared/data
      current_data_path = Rails.root.join 'data_test' # release_path/data
      shop.stub!(:path) { current_data_path }
      FileUtils.mkdir_p data_path
      FileUtils.ln_sf data_path, current_data_path
      theme = ShopTheme.create theme_id: theme_dark.id, role: theme_dark.role, shop: shop
      FileUtils.rm_rf "/tmp/deploy"
      FileUtils.rm_f current_data_path
      file = File.join theme.public_path, 'assets'
      target = File.readlink file
      target.should_not eql "#{current_data_path}/themes/1/assets" # 不能指向 release_path
      target.should eql "#{data_path}/themes/#{theme.id}/assets"
    end

  end

  def data
    {use_logo_image:"0", logo_color:"#ffffff", use_logobackground_image:"1", use_feature_image:"1", use_bannerbackground_image:"1", use_bannerurl_image:"danielweinand.com", use_header_image:"1", header_color:"#ffffff", body_background:"1", background_color:"#000000", text_color:"#000000", heading_color:"#000000", link_color:"#970000", linkhover_color:"#680000", mainnav_color:"#ffffff", mainnavhover_color:"#ffffff", mainnavline_color:"#ffffff", subnav_color:"#937c72", subnavhover_color:"#f1bda9", footertext_color:"#d5c4bf", footerlink_color:"#915c4f", footerline_color:"#674a43", checkoutheader_color:"#767676", header_font:"'Courier New', Courier, monospace", regular_font:"Helvetica, Arial, sans-serif", cart_graphic:"1", border_color:"#b7b7c2", border_grunge:"1", productborder_color:"#f2f2f2", productborderhover_color:"#ffffff", use_footer_image:"1", bgfooter_color:"#000000", customer_layout:"theme"}
  end

end
