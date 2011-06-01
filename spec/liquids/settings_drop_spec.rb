#encoding: utf-8
require 'spec_helper'


describe SettingsDrop do

  let(:shop) { Factory(:user).shop }

  it 'should get value' do
    variant = "{{ settings.text_color }}"
    result = "#444444"
    Liquid::Template.parse(variant).render('settings' => SettingsDrop.new(shop)).should eql result
  end

end
