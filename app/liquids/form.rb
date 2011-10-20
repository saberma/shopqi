class Form < Liquid::Block
  Syntax = /(#{Liquid::VariableSignature}+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @variable_name = $1
      @attributes = {}
    else
      raise SyntaxError.new("Syntax Error in 'form' - Valid syntax: form [article]")
    end
    super
  end

  def render(context)
    article = context[@variable_name]
    context.stack do
      wrap_in_form(article, render_all(@nodelist, context))
    end
  end

  def wrap_in_form(article, input)
    %Q{<form id="article-#{article.id}-comment-form" class="comment-form" method="post" action="/articles/#{article.id}/comments">\n#{input}\n</form>}
  end
end
