class CommentsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:blog)
  expose(:articles){ blog.articles } 
  expose(:article)

end
