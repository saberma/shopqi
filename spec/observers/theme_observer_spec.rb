require 'spec_helper'

describe ThemeObserver do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  let(:path) { path = File.join Rails.root, 'public', 'files', 'test', shop.id.to_s, 'theme'}

  let(:layout_theme_path) { File.join path, 'layout', 'theme.liquid' }

  describe 'Files' do

    it 'should be create' do
      File.exist?(path).should be_true
      File.exist?(layout_theme_path).should be_true
    end

    it 'should be delete' do
      shop.destroy
      File.exist?(path).should be_false
      File.exist?(layout_theme_path).should be_false
    end

  end

  describe ShopTheme do

    it 'should be create' do
      theme.should_not be_nil
    end

    it 'should get the app_theme' do
      theme.app_path.should eql "#{Rails.root}/app/themes/prettify"
    end

    it 'should get the public_theme' do
      theme.public_path.should eql "#{Rails.root}/public/files/test/#{shop.id}/theme"
    end

    it 'should get the asset_path' do
      theme.asset_path('style.css').should eql "#{Rails.root}/public/files/test/#{shop.id}/theme/assets/style.css.liquid"
      File.exist?(theme.asset_path('style.css')).should be_true
      theme.asset_path('shop.css').should eql "#{Rails.root}/public/files/test/#{shop.id}/theme/assets/shop.css"
      File.exist?(theme.asset_path('shop.css')).should be_true
    end

    it 'should get the layout_theme' do
      theme.layout_theme_path.should eql "#{Rails.root}/public/files/test/#{shop.id}/theme/layout/theme.liquid"
    end

    it 'should get the template_theme' do
      theme.template_path('index').should eql "#{Rails.root}/public/files/test/#{shop.id}/theme/templates/index.liquid"
    end

  end

  describe ShopThemeSetting do

    it 'should be read from file' do
      expect do
        shop.theme.settings.should_not be_empty
      end.should change(ShopTheme, :count)
    end

  end

end
