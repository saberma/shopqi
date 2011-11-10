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
    if @variable_name == 'customer_login'
      object = context['customer']
      render_customer_login_form context, object
    elsif @variable_name == 'article'
      object = context[@variable_name]
      render_article_form context, object
    end
  end

  private
  def render_customer_login_form(context, customer) # 登录表单
    context.stack do
      context['form'] = {
      }
      input = render_all(@nodelist, context)
      action = "/accounts/login"
      %Q{<form id="customer_login" method="post" action="/accounts/login">\n#{input}\n</form>}
    end
  end

  def render_article_form(context, article) # 发表评论表单
    context.stack do
      context['form'] = {
        'posted_successfully?' => context['posted_successfully'],
        'errors' => context['comment.errors'],
        'author' => context['comment.author'],
        'email'  => context['comment.email'],
        'body'   => context['comment.body']
      }
      input = render_all(@nodelist, context)
      action = "/blogs/#{article.blog.handle}/#{article.id}/comments"
      %Q{<form id="article-#{article.id}-comment-form" class="comment-form" method="post" action="#{action}">\n#{input}\n</form>}
    end
  end

end
