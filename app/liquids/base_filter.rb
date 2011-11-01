module BaseFilter #扩展标准filter http://j.mp/v8XGFK

  def json(object)
    object.to_json
  end

  def money(object) # ¥19.00
    shop = @context['shop'] #ShopDrop
    format = shop.money_format
    text = format.gsub '{{amount}}', object.to_s
    text.gsub '{{amount_no_decimals}}', object.round.to_s
  end

  def money_with_currency(object) # ¥19.00 元
    shop = @context['shop'] #ShopDrop
    format = shop.money_with_currency_format
    text = format.gsub '{{amount}}', object.to_s
    text.gsub '{{amount_no_decimals}}', object.round.to_s
  end

  def money_without_currency(object) # 19.00，currency指"¥"前缀和"元"后缀
    object
  end

end
