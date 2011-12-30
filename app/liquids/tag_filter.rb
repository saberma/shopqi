# encoding: utf-8
module TagFilter

  def stylesheet_tag(input)
    "<link href='#{input}' rel='stylesheet' type='text/css' media='all' />"
  end

  def script_tag(input)
    "<script src='#{input}' type='text/javascript'></script>"
  end

  def img_tag(input, alt = nil)
    "<img src='#{input}' alt='#{alt}' />"
  end

  def link_to(input, url)
    "<a href='#{url}'>#{input}</a>"
  end

  def link_to_type(input)
    "<a title='#{input}' href='/collections/types?q=#{input}'>#{input}</a>"
  end

  def link_to_vendor(input)
    "<a title='#{input}' href='/collections/vendors?q=#{input}'>#{input}</a>"
  end

  begin 'tag' # 标签

    def link_to_tag(alt, input)
      collection = @context['collection']
      "<a title='显示有#{alt}标签的商品' href='#{collection.url}/#{input}'>#{alt}</a>"
    end

    def link_to_add_tag(alt, input)
      collection = @context['collection']
      current_tags = @context['current_tags']
      alt_tags = [alt]
      input_tags = [input]
      if current_tags
        alt_tags += current_tags
        input_tags += current_tags
      end
      "<a title='显示有#{alt_tags.join('和')}标签的商品' href='#{collection.url}/#{input_tags.join('+')}'>#{alt}</a>"
    end

    def link_to_remove_tag(alt, input)
      collection = @context['collection']
      current_tags = @context['current_tags']
      input_tags = current_tags ? (current_tags - [input]) : []
      "<a title='取消#{alt}标签' href='#{collection.url}/#{input_tags.join('+')}'>#{alt}</a>"
    end

  end

  begin 'customer'

    def customer_login_link(input)
      "<a href='/account/login' id='customer_login_link'>#{input}</a>"
    end

    def customer_regist_link(input)
      "<a href='/account/signup' id='customer_regist_link'>#{input}</a>"
    end

    def customer_logout_link(input)
      "<a href='/account/logout' id='customer_logout_link'>#{input}</a>"
    end

    def edit_customer_address_link(title,id)
      %Q{<span class="action_link action_edit"><a href="#" onclick="ShopQi.CustomerAddress.toggleForm(#{id});return false">#{title}</a></span>}
    end

    def delete_customer_address_link(title,id)
      %Q{<a href="#" onclick="ShopQi.CustomerAddress.destroy(#{id});return false">#{title}</a>}
    end

  end

  def default_errors(errors) # 错误提示
    text = ''
    if errors and !errors.empty?
      text += '<div class="errors"><ul>'
      #用于支持显示当errors,为一数组的形式时
      if errors.is_a?(Array)
        errors.each do |error_message|
          text += "<li> #{error_message} </li>"
        end
      elsif errors.is_a?(String)
        text += "<li> #{errors} </li>"
      else
        errors.each do |attribute, errors_array|
          if errors_array.is_a?(Array)
            errors_array.each do |errors_content|
              text += "<li> #{attribute} #{errors_content} </li>"
            end
          else
            text += "<li> #{attribute} #{errors_array} </li>"
          end
        end
      end
      text += "</ul></div>"
    end
    text
  end

end
