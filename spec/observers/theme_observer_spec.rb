require 'spec_helper'

describe ThemeObserver do

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:path) { File.join Rails.root, 'data', 'shops', Rails.env, shop.id.to_s, 'themes', theme.id.to_s }

  let(:public_path) { File.join Rails.root, 'public', 's', 'files', Rails.env, shop.id.to_s, 'theme', theme.id.to_s }

  let(:layout_theme_path) { File.join path, 'layout', 'theme.liquid' }

  before(:each) do
    shop.themes.install theme_dark
  end

  describe 'Files' do

    it 'should be create' do
      File.exist?(path).should be_true
      File.exist?(public_path).should be_true
      File.exist?(layout_theme_path).should be_true
    end

    it 'should be delete' do
      path
      shop.destroy
      File.exist?(path).should be_false
      File.exist?(public_path).should be_false
      File.exist?(layout_theme_path).should be_false
    end

  end

  describe ShopTheme do

    it 'should be create' do
      theme.should_not be_nil
    end

    it 'should get the public_theme' do
      theme.public_path.should eql "#{Rails.root}/public/s/files/#{Rails.env}/#{shop.id}/theme/#{theme.id}"
    end

    it 'should get the asset_path' do
      theme.asset_path('stylesheet.css').should eql "#{Rails.root}/data/shops/#{Rails.env}/#{shop.id}/themes/#{theme.id}/assets/stylesheet.css.liquid"
      File.exist?(theme.asset_path('stylesheet.css')).should be_true
      theme.asset_path('ie7.css').should eql "#{Rails.root}/data/shops/#{Rails.env}/#{shop.id}/themes/#{theme.id}/assets/ie7.css"
      File.exist?(theme.asset_path('ie7.css')).should be_true
    end

    it 'should get the layout_theme' do
      theme.layout_theme_path.should eql "#{Rails.root}/data/shops/#{Rails.env}/#{shop.id}/themes/#{theme.id}/layout/theme.liquid"
    end

    it 'should get the template_theme' do
      theme.template_path('index').should eql "#{Rails.root}/data/shops/#{Rails.env}/#{shop.id}/themes/#{theme.id}/templates/index.liquid"
    end

  end

  describe ShopThemeSetting do

    it 'should be read from file' do
      shop.theme.settings.should_not be_empty
    end

  end

end
