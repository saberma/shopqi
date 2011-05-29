#encoding: utf-8
require 'spec_helper'

describe PageDrop do

  let(:shop) { Factory(:user).shop }

  it 'should get about-us page' do
    page_drop = PageDrop.new shop
    page_drop.send('about-us').content.should_not be_nil
  end

end
