#encoding: utf-8
require 'spec_helper'

describe PagesDrop do

  let(:shop) { Factory(:user).shop }

  let(:page) { shop.pages.where(handle: 'about-us').first }

  let(:assign) { { 'pages' => PagesDrop.new(shop)}}

  it 'should get about-us page' do
    text = "{{ pages.about-us.title }}"
    Liquid::Template.parse(text).render(assign).should eql page.title
  end

end
