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

end
