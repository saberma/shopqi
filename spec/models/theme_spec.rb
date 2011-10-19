# encoding: utf-8
require 'spec_helper'
require 'carrierwave/test/matchers'

describe Theme do
  include CarrierWave::Test::Matchers

  it 'should get default' do
    Theme.default.should_not be_nil
  end

  describe 'file' do

    let(:theme) { Theme.create name: '乔木林地', style: '黑桤木' }

    let(:zip_path) { Rails.root.join('spec', 'factories', 'data', 'themes', 'woodland.tar.bz2') }

    it 'should be unzip', focus: true do # 上传的文件要解压至current目录
      @uploader = ThemeUploader.new(theme, :file)
      @uploader.store!(File.open(zip_path))
      File.exists?(theme.path).should be_true
    end

  end

  describe 'oauth2' do

    it 'should get client_id' do
      Theme.client_id.should_not be_blank
    end

    it 'should get client_secret' do
      Theme.client_secret.should_not be_blank
    end

  end

end
