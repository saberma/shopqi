require 'spec_helper'

describe ThemeObserver do

  let(:shop) { Factory(:user).shop }

  let(:path) { path = File.join Rails.root, 'public', 'themes', 'test', shop.id.to_s }

  let(:theme) { File.join path, 'layout', 'theme.liquid' }

  describe 'Files' do

    it 'should be create' do
      File.exist?(path).should be_true
      File.exist?(theme).should be_true
    end

    it 'should be delete' do
      shop.destroy
      File.exist?(path).should be_false
      File.exist?(theme).should be_false
    end

  end

  describe Shop do

    it 'should get the app_theme' do
      shop.app_theme.should eql "#{Rails.root}/app/themes/#{shop.theme}"
    end

    it 'should get the public_theme' do
      shop.public_theme.should eql "#{Rails.root}/public/themes/test/#{shop.id}"
    end

    it 'should get the layout_theme' do
      shop.layout_theme.should eql "#{Rails.root}/public/themes/test/#{shop.id}/layout/theme.liquid"
    end

    it 'should get the template_theme' do
      shop.template_theme('index').should eql "#{Rails.root}/public/themes/test/#{shop.id}/templates/index.liquid"
    end

  end

  describe ThemeSettings do

    it 'should be create' do
    end

  end

end
