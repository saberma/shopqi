class Admin::CommentsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop}
  expose(:blogs){ shop.blogs }
  expose(:blog)
  expose(:articles){ blog.articles }
  expose(:article)
  expose(:comments){
    if params[:search]
      shop.comments.metasearch(params[:search]).all
    else
      shop.comments
    end
  }
  expose(:comment)

  expose(:comments_json){
    comments.to_json({
      include:{ article: { only: [:id, :blog_id,:title]} }
    })
  }
  expose(:status){ KeyValues::CommentState.hash}

  def set
    operation = params[:operation].to_sym
    ids = params[:comments]
    if :mark_spam == operation
      comments.where(id:ids).update_all status: 'spam'
    elsif [:mark_non_spam,:approve].include? operation
      comments.where(id:ids).update_all status: 'published'
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
