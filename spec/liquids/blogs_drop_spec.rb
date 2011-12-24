#encoding: utf-8
require 'spec_helper'

describe BlogsDrop do

  let(:shop) { Factory(:user).shop }

  let(:blog) { shop.blogs.where(handle: 'news').first }

  let(:article1) { blog.articles.create title: '新店开张', body_html: '全场5折' }

  let(:article2) { blog.articles.create title: '圣诞优惠', body_html: '全场免运费' }

  let(:assign) { { 'blogs' => BlogsDrop.new(shop) , 'blog' => BlogDrop.new(blog)}}

  it 'should get news' do
    text = "{{ blogs.news.title }}"
    Liquid::Template.parse(text).render(assign).should eql blog.title
  end

  describe BlogDrop do

    describe ArticleDrop do

      before { [article1, article2] } # blog.articles是按id倒序排序，会返回article2, article1

      it 'should get previous' do
        text = "{{ blog.previous_article }}"
        assign['article'] = ArticleDrop.new article1
        Liquid::Template.parse(text).render(assign).should eql "/blogs/news/#{article2.id}"
        assign['article'] = ArticleDrop.new article2 # 没有上一条
        Liquid::Template.parse(text).render(assign).should be_blank
      end

      it 'should get next' do
        text = "{{ blog.next_article }}"
        assign['article'] = ArticleDrop.new article2
        Liquid::Template.parse(text).render(assign).should eql "/blogs/news/#{article1.id}"
        assign['article'] = ArticleDrop.new article1 # 没有下一条
        Liquid::Template.parse(text).render(assign).should be_blank
      end

    end

    context 'exist' do

      it 'should get articles' do
        text = "{{ blogs.news.articles | size }}"
        Liquid::Template.parse(text).render(assign).should eql '0'
      end

      it 'should get articles count' do # 文章总数
        article1
        text = "{{ blogs.news.articles_count }}"
        Liquid::Template.parse(text).render(assign).should eql '1'
      end

      it 'should get the comment enable true for blog articles' do
        text = "{{ blog.comments_enabled? }}"
        Liquid::Template.parse(text).render(assign).should eql "false"
      end

    end

    context 'missing' do # 不存在记录

      it 'should get articles' do
        text = "{{ blogs.noexist.articles.size }}"
        Liquid::Template.parse(text).render(assign).should eql '0'
      end

    end

  end

end
