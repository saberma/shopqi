module UrlFilter

  def asset_url(input)
    "/themes/#{@context['shop'].id}/assets/#{input}"
  end

  def global_asset_url(input)
    "/global/#{input}"
  end

  def product_img_url(input, size)
    "#{input[0..-5]}_#{size}#{input[-4..-1]}"
  end

end
