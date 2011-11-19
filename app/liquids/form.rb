class Form < Liquid::Block
  Syntax = /(#{Liquid::VariableSignature}+)/
  ComplexSyntax = /(#{Liquid::QuotedFragment}+)\s*,\s*(\S*)/

  def initialize(tag_name, markup, tokens)
    if markup =~ ComplexSyntax
      @type = $2
      @variable_name = lambda do ;$1 =~ Syntax ; $1 end.call
    elsif markup =~ Syntax
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
    elsif @variable_name == 'recover_customer_password'
      object = context['customer']
      render_recover_customer_password_form context,object
    elsif @variable_name == 'reset_customer_password'
      object = context['customer']
      render_reset_customer_password_form context,object
    elsif @variable_name == 'regist_new_customer'
      object = context['customer']
      render_regist_customer_form context,object
    elsif @variable_name == 'customer_address'
      object = context[@type]
      render_address_form context,object,@type
    elsif @variable_name == 'article'
      object = context[@variable_name]
      render_article_form context, object
    end
  end

  private
  def render_customer_login_form(context, customer) # 登录表单
    context.stack do
      context['form'] = {
        'errors' => context['errors'],
        'password_needed' => true,
      }
      input = render_all(@nodelist, context)
      action = "/account/login"
      %Q{<form id="customer_login" method="post" action="#{action}">\n#{input}\n</form>}
    end
  end

  def render_recover_customer_password_form(context,customer)
    context.stack do
      context['form'] = {
        'errors' => context['recover_errors'],
      }
      input = render_all(@nodelist, context)
      action = "/account/customer/password"
      %Q{<form id="recover_customer_password" method="post" action="#{action}">\n#{input}\n</form>}
    end
  end

  def render_reset_customer_password_form(context,customer)
    context.stack do
      context['form'] = {
        'errors' => context['customer.errors'],
        'email'  => context['customer.email'],
        'reset_password_token' => context['customer.reset_password_token']
      }
      input = render_all(@nodelist, context)
      action = "/account/customer/password"
      %Q{<form id="reset_customer_password" method="post" action="#{action}">\n#{input}\n</form>}
    end
  end

  def render_regist_customer_form(context,customer)
    context.stack do
      context['form'] = {
        'errors' => context['customer.errors'],
      }
      input = render_all(@nodelist, context)
      action = "/account/customer"
      %Q{<form id="regist_new_customer" method="post" action="#{action}">\n#{input}\n</form>}
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

  def render_address_form(context,address,type)
    context.stack do
      context['address'] = address
      context['form'] = {
        'errors' => context['address.errors'],
        'id' => context['address.id']  ,
        'name' => context['address.name']  ,
        'company' => context['address.company']  ,
        'address1' => context['address.address1']  ,
        'city' => context['address.city']  ,
        'country' => context['address.country']  ,
        'province' => context['address.province']  ,
        'phone' => context['address.phone'] ,
        'set_as_default_checkbox' => context['address.set_as_default_checkbox']  ,
        'province_option_tags' => context['address.province_option_tags']
      }
      input = render_all(@nodelist, context)
      if type == 'customer.new_address'
        action = "/account/addresses"
        %Q{<form id="add_address" class="customer_address edit_address" method="post" action="#{action}">\n#{input}\n</form>}
      else
        action = "/account/addresses/#{address.id}"
        %Q{<form id="address_form_#{address.id}" class="customer_address edit_address" method="post" action="#{action}">\n<input name="_method" type="hidden" value="put" />\n#{input}\n</form>}
      end
    end
  end

end
