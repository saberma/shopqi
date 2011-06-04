#encoding: utf-8
require 'spec_helper'


describe SettingsDrop do

  let(:shop) { Factory(:user).shop }

  let(:assign) { {'settings' => SettingsDrop.new(shop)} }

  it 'should get value' do
    variant = "{{ settings.text_color }}"
    result = "#000000"
    Liquid::Template.parse(variant).render(assign).should eql result
  end

  it 'should get boolean value' do
    variant = "{% if settings.use_bg_image %}logo.png{% endif %}"
    result = ''
    Liquid::Template.parse(variant).render(assign).should eql result
  end

end
