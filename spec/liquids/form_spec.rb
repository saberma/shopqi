#encoding: utf-8
require 'spec_helper'

describe Form do

  let(:shop) { Factory(:user_liwh).shop }

  let(:blog) { shop.blogs.where(handle: 'news').first }

  let(:article) { Article.create title: '文章', shop_id: shop.id, blog_id: blog.id , body_html: '新文章。。。'}

  let(:article_drop) { ArticleDrop.new(article) }

  it 'should get the right form tag' do
    variant = "{% form article %}{% endform %}"
    assign = { 'article' => article_drop }
    Liquid::Template.parse(variant).render(assign).should eql "<form id=\"article-#{article.id}-comment-form\" class=\"comment-form\" method=\"post\" action=\"/blogs/#{article.blog.handle}/#{article.id}/comments\">\n\n</form>"
  end

end
