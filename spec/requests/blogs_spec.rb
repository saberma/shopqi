#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Blogs" do

  include_context 'login admin'

  describe "GET /admin/blogs" do

    it "works! ",js:true do
      visit pages_path
      #新增博客
      click_on '新增博客'
      fill_in 'blog[title]', with: '商品介绍'
      select '禁用评论', form: 'blog_commentable'
      click_on '新增'
      page.should have_content('商品介绍')


      #修改博客
      click_on '修改'
      select '允许评论,需审核', from: 'blog_commentable'
      click_on '保存'

      #新增文章
      click_on '新增文章'
      page.execute_script("$.fn.off = true")
      fill_in 'article[title]', with: '新品上市'
      find('#kindeditor').visible?.should be false

      click_on '新增'
      find('#flashnotice').should have_content('新增成功')
      page.should have_content('新品上市')

      #修改文章
      select '隐藏', :from => 'article_published'
      find('#flashnotice').should have_content('修改成功!')

      #删除文章
      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should_not have_content('新品上市')

      #删除博客
      visit blog_path(Blog.first)
      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
    end

  end

end
