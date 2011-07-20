class CommentDrop < Liquid::Drop
  def initialize(comment)
    @comment = comment
  end

  delegate :created_at, :author, to: :@comment

  def content
    @comment.body.html_safe
  end

end
