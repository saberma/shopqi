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
  expose(:comments_json){
    comments.to_json
  }

  def set
  end

end
