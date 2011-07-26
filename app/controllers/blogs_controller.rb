#encoding: utf-8
class BlogsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:blogs){ current_user.shop.blogs}
  expose(:blog)
  expose(:articles){
    if params[:tag]
      blog.articles.where(tag: params[:tag])
    else
      blog.articles
    end
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
