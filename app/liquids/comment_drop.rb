class CommentDrop < Liquid::Drop
  def initialize(comment)
    @comment = comment
  end

  delegate :created_at

  def author
    @comment.name
  end

  def content
    @comment.comment.html_safe
  end

end
