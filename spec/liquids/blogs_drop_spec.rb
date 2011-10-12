#encoding: utf-8
require 'spec_helper'

describe BlogsDrop do

  let(:shop) { Factory(:user).shop }

  let(:blog) { shop.blogs.where(handle: 'news').first }

  let(:assign) { { 'blogs' => BlogsDrop.new(shop) , 'blog' => BlogDrop.new(blog)}}

  it 'should get news' do
    text = "{{ blogs.news.title }}"
    Liquid::Template.parse(text).render(assign).should eql blog.title
  end

  describe BlogDrop do

    it 'should get articles' do
      text = "{{ blogs.news.articles | size }}"
      Liquid::Template.parse(text).render(assign).should eql '0'
    end

    it 'should get the comment enable true for blog articles' do
      text = "{{ blog.comments_enabled? }}"
      Liquid::Template.parse(text).render(assign).should eql "false"
    end

  end

end
