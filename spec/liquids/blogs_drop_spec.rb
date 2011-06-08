#encoding: utf-8
require 'spec_helper'

describe BlogsDrop do

  let(:shop) { Factory(:user).shop }

  let(:blog) { shop.blogs.where(handle: 'latest-news').first }

  let(:assign) { { 'blogs' => BlogsDrop.new(shop)}}

  it 'should get latest-news' do
    text = "{{ blogs.latest-news.title }}"
    Liquid::Template.parse(text).render(assign).should eql blog.title
  end

  describe BlogDrop do

    it 'should get articles' do
      text = "{{ blogs.latest-news.articles | size }}"
      Liquid::Template.parse(text).render(assign).should eql '0'
    end

  end

end
