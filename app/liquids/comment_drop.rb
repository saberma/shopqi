class CommentDrop < Liquid::Drop
  def initialize(comment)
    @comment = comment
  end

  delegate :created_at, :author,:email,:body, to: :@comment

  def content
    @comment.body.html_safe
  end

  def errors
    @comment.errors.messages.stringify_keys if @comment.errors
  end
end
