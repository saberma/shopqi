#encoding: utf-8
require 'spec_helper'

describe BlogsDrop do

  let(:shop) { Factory(:user).shop }

  it 'should get latest-news' do
    blogs_drop = BlogsDrop.new shop
    blogs_drop.send('latest-news').should_not be_nil
  end

  describe BlogDrop do

    it 'should get articles' do
      blog_drop = BlogDrop.new shop.blogs.where(handle: 'latest-news').first
      blog_drop.articles.should be_empty
    end

  end

end
