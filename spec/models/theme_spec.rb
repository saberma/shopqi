# encoding: utf-8
require 'spec_helper'
require 'carrierwave/test/matchers'

describe Theme do
  include CarrierWave::Test::Matchers

  let(:theme) { Factory :theme_woodland_dark }

  it 'should get default' do
    theme
    Theme.default.should_not be_nil
  end

  describe 'file' do

    it 'should be unzip', focus: true do # 上传的文件要解压至current目录
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
