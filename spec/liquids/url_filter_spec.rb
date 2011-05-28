require 'spec_helper'

include UrlFilter
describe UrlFilter do

  let(:shop) { Factory(:user).shop }

  it 'should get asset_url' do
    asset_url('shop.css').should eql "/themes/#{shop.id}/assets/shop.css"
  end

  it 'should get global_asset_url' do
    global_asset_url('textile.css').should eql '/global/textile.css'
  end

end
