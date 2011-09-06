module UrlFilter

  def asset_url(input)
    shop = @context['shop'] #ShopDrop
    "/#{shop.asset_path(input)}"
  end

  def global_asset_url(input)
    "/s/global/#{input}"
  end

  def shopqi_asset_url(input)
    "/s/shopqi/#{input}"
  end

  def product_img_url(photo, size)
    photo ? photo.version(size) : "/assets/admin/no-image-#{size}.gif"
  end

end
