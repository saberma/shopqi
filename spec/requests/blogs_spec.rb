#encoding: utf-8
require 'spec_helper'
require 'shared_stuff'

describe "Blogs", js:true do

  include_context 'login admin'

  let(:shop) { user_admin.shop }

  let(:blog) { shop.blogs.where(handle: 'news').first }

  describe "GET /admin/blogs" do

    it "should be add" do # 新增
      visit pages_path
      click_on '新增博客'
      fill_in 'blog[title]', with: '商品介绍'
      select '禁用评论', form: 'blog_commentable'
      click_on '新增'
      page.should have_content('商品介绍')
    end

    it "should be edit" do # 修改
      visit blog_path(blog)
      click_on '修改'
      select '允许评论,需审核', from: 'blog_commentable'
      click_on '保存'
      page.should have_content('修改成功!')
    end

    it "should be destroy" do # 删除
      visit blog_path(blog)
      page.execute_script("window.confirm = function(msg) { return true; }")
      find('.del').click
      page.should have_content('删除成功!')
    end

    describe Article do # 文章

      let(:article) { blog.articles.create title: '全场免运费' }

      it "should be validate" do # 校验
        visit blog_path(blog)
        click_on '新增文章' #新增文章(title为nil时)
        page.execute_script("$.fn.off = true")
        find('#kindeditor').visible?.should be false
        click_on '新增'
        page.should_not have_content('新增成功')
        page.should have_content('不能为空')
      end

      it "should be add" do # 新增文章
        visit new_blog_article_path(blog)
        fill_in 'article[title]', with: '新品上市'
        click_on '新增'
        page.should have_content('新增成功')
        page.should have_content('新品上市')
      end

      it "should be edit" do # 修改文章
        visit blog_article_path(blog, article)
        select '隐藏', :from => 'article_published'
        page.should have_content('修改成功!')
      end

      it "should be destroy" do # 删除文章
        visit blog_article_path(blog, article)
        page.execute_script("window.confirm = function(msg) { return true; }")
        find('.del').click
        page.should have_content('删除成功!')
        page.should_not have_content('新品上市')
      end

      describe Comment do # 评论

        let(:comment) { article.comments.create(status: 'spam', email: 'mahb45@gmail.com', body: '新评论内容', author: 'admin') }

        before { comment }

        it "should be edit" do # 新增评论
          visit pages_path
          within("#comments-list")  do
            page.should have_content("新评论内容")
            page.should have_link("mahb45@gmail.com")
            page.should have_content("不为垃圾评论")
            find(".action.btn.approve").click # 切换为普通评论
            page.should have_content("垃圾评论")
            page.should have_no_content("不为垃圾评论")
            page.execute_script("window.confirm = function(msg) { return true; }")
            find('.action.destroy').click
            page.should_not have_content('新评论内容') # 删除评论
          end
        end

      end

    end

  end

end
