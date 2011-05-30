#encoding: utf-8
require 'spec_helper'

describe BlogDrop do

  let(:shop) { Factory(:user).shop }

  let(:latest_news) do
    Factory(:welcome, shop: shop)
    shop.blogs.latest
  end

  it 'should get latest-news' do
    blog_drop = BlogDrop.new shop
    blog_drop.send('latest-news').should_not be_nil
  end

end
