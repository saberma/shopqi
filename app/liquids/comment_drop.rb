class CommentDrop < Liquid::Drop
  def initialize(comment)
    @comment = comment
  end

  delegate :created_at, :author,:email,:body,:errors, to: :@comment

  def content
    @comment.body.html_safe
  end

end
