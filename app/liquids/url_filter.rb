module UrlFilter

  def asset_url(input)
    "/themes/#{@context['shop'].id}/assets/#{input}"
  end

  def global_asset_url(input)
    "/global/#{input}"
  end

end
