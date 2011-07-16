#encoding: utf-8
require 'spec_helper'

describe Form do

  let(:shop) { Factory(:user_liwh).shop }

  let(:blog) { Factory(:welcome)}

  let(:article) { Article.new title: '文章', shop: shop,blog: blog , body_html: '新文章。。。'}

  let(:article_drop) { ArticleDrop.new(article) }

  it 'should get current_page' do
    variant = "{% form article %}{% endform %}"
    assign = { 'article' => article_drop }
    Liquid::Template.parse(variant).render(assign).should eql "<form method='post action=/blogs/#{blog.handle}/#{article.id}/comments'"
  end

end
