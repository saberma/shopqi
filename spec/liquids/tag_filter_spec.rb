require 'spec_helper'

describe TagFilter do

  it 'should get stylesheet_tag' do
    variant = "{{ 'textile.css' | stylesheet_tag }}"
    Liquid::Template.parse(variant).render.should eql "<link href='textile.css' rel='stylesheet' type='text/css' media='all' />"
  end

  it 'should get script_tag' do
    variant = "{{ 'jquery.js' | script_tag }}"
    Liquid::Template.parse(variant).render.should eql "<script src='jquery.js' type='text/javascript'></script>"
  end

  it 'should get img_tag' do
    variant = "{{ 'avatar.jpg' | img_tag }}"
    Liquid::Template.parse(variant).render.should eql "<img src='avatar.jpg' alt='' />"
  end

end
