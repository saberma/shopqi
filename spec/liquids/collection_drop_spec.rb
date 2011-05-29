#encoding: utf-8
require 'spec_helper'

describe CollectionDrop do

  let(:shop) { Factory(:user).shop }

  it 'should get frontpage' do
    collection_drop = CollectionDrop.new shop
    collection_drop.frontpage.products.should eql []
  end

end
