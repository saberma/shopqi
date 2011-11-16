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
    "<a title=#{input} href='/collections/types?q=#{input}'>#{input}</a>"
  end

  def link_to_vendor(input)
    "<a title=#{input} href='/collections/vendors?q=#{input}'>#{input}</a>"
  end

  begin 'customer'

    def customer_login_link(input)
      "<a href='/account/login' id='customer_login_link'>#{input}</a>"
    end

    def customer_regist_link(input)
      "<a href='/account/sign_up' id='customer_regist_link'>#{input}</a>"
    end

    def customer_logout_link(input)
      "<a href='/account/logout' id='customer_logout_link'>#{input}</a>"
    end

  end

  def default_errors(errors) # 错误提示(暂不支持顾客登录失败提示)
    text = ''
    if errors and !errors.empty?
      text += '<div class="errors"><ul>'
      #用于支持显示当errors,为一数组的形式时
      if errors.is_a?(Array)
        errors.each do |error_message|
          text += "<li> #{error_message} </li>"
        end
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
