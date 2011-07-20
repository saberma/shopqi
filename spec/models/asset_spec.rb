# encoding: utf-8
require 'spec_helper'

describe Asset do

  let(:shop) { Factory(:user).shop }

  let(:theme) { shop.theme }

  it 'should be list' do
    list = Asset.all(theme)
    list.should_not be_empty
    ["assets", "config", "layout", "snippets", "templates"].each do |key|
      list.has_key?(key).should be_true

    end
  end

  describe '#create' do

    it 'should save layout' do # 指明蓝本
      Asset.create theme, 'layout/admin.liquid', 'layout/theme.liquid'
      File.exists?(File.join(theme.public_path, 'layout/admin.liquid')).should be_true
    end

    it 'should save template' do # 蓝本在app/themes/shopqi中
      Asset.create theme, 'templates/customers/login.liquid'
      File.exists?(File.join(theme.public_path, 'templates/customers/login.liquid')).should be_true
    end

    it 'should save snippet' do # 不需要蓝本
      Asset.create theme, 'snippets/hot-products.liquid'
      File.exists?(File.join(theme.public_path, 'snippets/hot-products.liquid')).should be_true
    end

  end

end
