#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Blogs" do

  include_context 'login admin'
  let(:shop) { user_admin.shop }

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

      #新增文章(title为nil时)
      click_on '新增文章'
      page.execute_script("$.fn.off = true")
      find('#kindeditor').visible?.should be false
      click_on '新增'
      page.should_not have_content('新增成功')
      page.should have_content('不能为空')

      fill_in 'article[title]', with: '新品上市'
      click_on '新增'
      page.should have_content('新增成功')
      page.should have_content('新品上市')

      #修改文章
      select '隐藏', :from => 'article_published'
      page.should have_content('修改成功!')

      #测试评论
      #增加评论
      blog = Blog.find_by_title('商品介绍')
      article = blog.articles.first
      Comment.create(article_id: article.id,shop_id: shop.id, status: 'spam',email: 'liwh87@gmail.com', body: '新评论内容', author: 'admin')
      blog.reload

      visit blog_article_path(blog,article)

      within(:xpath, "//table[@id='comments-list']/tbody/tr")  do
        has_content?("新评论内容").should be_true
        has_link?("liwh87@gmail.com").should be_true
        has_content?("不为垃圾评论").should be_true
        find(".action.btn.approve").click
        has_content?("垃圾评论").should be_true
        has_no_content?('不为垃圾评论').should be_true
        page.execute_script("window.confirm = function(msg) { return true; }")
        find('.action.destroy').click
        page.should_not have_content('新评论内容') # 删除评论
      end

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
