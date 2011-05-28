module UrlFilter

  def asset_url(input)
    "/themes/#{shop.id}/assets/#{input}"
  end

  def global_asset_url(input)
    "/global/#{input}"
  end

end
