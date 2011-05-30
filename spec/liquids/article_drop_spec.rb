#encoding: utf-8
require 'spec_helper'


describe ArticleDrop do

  let(:shop) { Factory(:user).shop }

  let(:article) { Article.new title: '优惠', body_html: '全场5折' }

  let(:article_drop) { ArticleDrop.new article }

  it 'should get title' do
    article_drop.title.should eql '优惠'
  end

  it 'should get content' do
    article_drop.content.should eql '全场5折'
  end

end
