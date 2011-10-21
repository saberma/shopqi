#encoding: utf-8
require 'spec_helper'


describe SettingsDrop do

  let(:theme_dark) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  let(:assign) { {'settings' => SettingsDrop.new(shop.theme)} }

  before(:each) do
    shop.themes.install theme_dark
  end

  it 'should get value' do
    variant = "{{ settings.text_color }}"
    result = "#333333"
    Liquid::Template.parse(variant).render(assign).should eql result
  end

  it 'should get boolean value' do
    variant = "{% if settings.use_logo_image %}logo.png{% endif %}"
    result = ''
    Liquid::Template.parse(variant).render(assign).should eql result
  end

end
