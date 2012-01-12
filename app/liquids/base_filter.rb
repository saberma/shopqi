module BaseFilter #扩展标准filter http://j.mp/v8XGFK

  def json(object)
    object.to_json
  end

  def pluralize(input, singular, plural) # input为奇数返回singular, 否则plural
    input == 1 ? singular : plural
  end

  def money(object) # ¥19.00
    shop = @context['shop'] #ShopDrop
    is_email = @context['is_email']
    format = shop.money_format
    format = shop.money_in_emails_format if is_email
    text = format.gsub '{{amount}}', object.to_s
    text.gsub '{{amount_no_decimals}}', object.round.to_s
  end

  def money_with_currency(object) # ¥19.00 元
    shop = @context['shop'] #ShopDrop
    is_email = @context['is_email']
    format = shop.money_with_currency_format
    format = shop.money_with_currency_in_emails_format if is_email
    text = format.gsub '{{amount}}', object.to_s
    text.gsub '{{amount_no_decimals}}', object.round.to_s
  end

  def money_without_currency(object) # 19.00，currency指"¥"前缀和"元"后缀
    object
  end

  def handleize(input) # 转化可用于url的字符串(中文转为英文，并去掉%@*$等特殊字符)
    Models::Handle.handleize(input)
  end
  alias :handle :handleize

  def camelize(input)
    input && input.gsub(/\s+/, '_').camelize
  end

end
