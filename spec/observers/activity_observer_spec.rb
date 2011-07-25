# encoding: utf-8
require 'spec_helper'

describe ActivityObserver do

  let(:shop) { Factory(:user).shop }
  let(:blog){ Factory :blog, shop: shop}
  let(:article){ Article.create title: 'aaa', blog: blog, body_html: 'aaaaa'}

  context ".after_create" do
    it "should be insert new activity" do
      #初始化shop中包含了创建首页商品集合,和博客最新动态
      expect do
        shop
      end.to change(Activity,:count).by(2)

      expect do
        blog
      end.to change(Activity,:count).by(1)

      expect do
        article
      end.to change(Activity,:count).by(1)

      expect do
        blog.update_attributes "title = 'bbbbb'"
      end.to change(Activity,:count).by(1)

      expect do
        article.update_attributes "title = 'cccc'"
      end.to change(Activity,:count).by(1)


      expect do
        article.destroy
      end.to change(Activity,:count).by(1)

      expect do
        blog.destroy
      end.to change(Activity,:count).by(1)

    end
  end
end
