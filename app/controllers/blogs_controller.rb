#encoding: utf-8
class BlogsController < AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:blogs){ current_user.shop.blogs}
  expose(:blog)
  expose(:articles){
    if params[:search]
      blog.articles.metasearch(params[:search]).all
    else
      blog.articles
    end
  }
  expose(:status) { KeyValues::PublishState.hash }
  expose(:authors){
    blog.articles.select(:author).map(&:author).uniq
  }
  expose(:tags){
    blog.articles.map(&:tags).flatten.map(&:name).uniq
  }

  def create
    if blog.save
      render action:'show'
    else
      render action:'new'
    end
  end

  def update
    if blog.save
      render action:"show"
    else
      render action:'edit'
    end
  end

  def destroy
    blog.destroy
    respond_to do |format|
      format.js { render template: "pages/destroy" }
    end
  end
end
