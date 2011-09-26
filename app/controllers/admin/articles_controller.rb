class ArticlesController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop) { current_user.shop }
  expose(:blogs){ shop.blogs}
  expose(:blog)
  expose(:articles){ blog.articles }
  expose(:article)
  expose(:comments){ article.comments }
  expose(:tags) { shop.tags.previou_used(2) }

  def create
    article.user = current_user
    blog = shop.blogs.find(params[:article][:blog_id])
    if article.save
      flash[:notice] = I18n.t("flash.actions.#{action_name}.notice")
      redirect_to blog_article_path(blog,article)
    end
  end

  def update
    article.user = current_user
    if article.save
      flash[:notice] = I18n.t("flash.actions.#{action_name}.notice")
      respond_to do |format|
        format.html { redirect_to blog_article_path(blog,article) }
        format.js { render :template => "shared/msg" }
      end
    end
  end

  def destroy
    article.destroy
  end

end
