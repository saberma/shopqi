module TagFilter

  def stylesheet_tag(input)
    "<link href='#{input}' rel='stylesheet' type='text/css' media='all' />"
  end

  def script_tag(input)
    "<script src='#{input}' type='text/javascript'></script>"
  end

  def img_tag(input)
    "<img src='#{input}' alt='' />"
  end

end
