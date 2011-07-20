class CommentsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop}
  expose(:blog)
  expose(:articles){ blog.articles }
  expose(:article)
  expose(:comments){
    shop.comments
  }
  expose(:comment)

  expose(:comments_json){
    comments.to_json({
      include:{ article: { only: [:id, :blog_id,:title]} }
    })
  }

  def set
    operation = params[:operation].to_sym
    ids = params[:comments]
    if false
    elsif operation == :destroy
      comments.find(ids).map(&:destroy)
    end
    render nothing: true
  end

  def destroy
    comment.destroy
    render json: comment
  end

  def update
    comment.save
    render json: comment.to_json({include:{ article: { only: [:id, :blog_id,:title]} }})
  end
end
