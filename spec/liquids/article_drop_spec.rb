#encoding: utf-8
require 'spec_helper'


describe ArticleDrop do

  let(:shop) { Factory(:user).shop }

  let(:blog) { shop.blogs.where(handle: 'news').first }

  let(:article) { blog.articles.build title: '优惠', body_html: '全场5折' }

  let(:article_drop) { ArticleDrop.new article }

  it 'should get title' do
    result = '优惠'
    variant = "{{ article.title }}"
    liquid(variant).should eql result
  end

  it 'should get content' do
    result = '全场5折'
    variant = "{{ article.content }}"
    liquid(variant).should eql result
  end

  describe CommentDrop do

    it 'should get comments size' do
      result = '0'
      variant = "{{ article.comments_count }}"
      liquid(variant).should eql result
    end

    it 'should get comments enabled' do
      result = blog.comments_enabled?.to_s
      variant = "{{ article.comments_enabled? }}"
      liquid(variant).should eql result
    end

  end

  private
  def liquid(variant, assign = {'article' => article_drop})
    Liquid::Template.parse(variant).render(assign)
  end


end
