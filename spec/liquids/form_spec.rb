#encoding: utf-8
require 'spec_helper'

describe Form do

  let(:shop) { Factory(:user_liwh).shop }

  describe Article do

    let(:blog) { shop.blogs.where(handle: 'news').first }

    let(:article) { Article.create title: '文章', shop_id: shop.id, blog_id: blog.id , body_html: '新文章。。。'}

    let(:article_drop) { ArticleDrop.new(article) }

    it 'should get the right form tag' do
      variant = "{% form article %}{% endform %}"
      assign = { 'article' => article_drop }
      Liquid::Template.parse(variant).render(assign).should eql "<form id=\"article-#{article.id}-comment-form\" class=\"comment-form\" method=\"post\" action=\"/blogs/#{article.blog.handle}/#{article.id}/comments\">\n\n</form>"
    end

  end

  describe Customer do

    let(:customer) { Factory :customer_saberma, shop: shop }

    let(:customer_drop) { CustomerDrop.new customer }

    it 'should show login from', focus: true do
      variant = "{% form 'customer_login' %} {{ form.errors | default_errors }} {% if form.password_needed %}password{% endif %} {% endform %}"
      assign = { 'customer' => customer_drop }
      result = "<form id=\"customer_login\" method=\"post\" action=\"/account/login\">\n  password \n</form>"
      Liquid::Template.parse(variant).render(assign).should eql result
    end

  end

end
