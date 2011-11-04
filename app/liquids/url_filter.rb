module UrlFilter

  def asset_url(input)
    shop = @context['shop'] #ShopDrop
    "#{ActionController::Base.asset_host}#{shop.asset_url(input)}"
  end

  def global_asset_url(input)
    add_mtime "s/global/#{input}"
  end

  def shopqi_asset_url(input)
    add_mtime "s/shopqi/#{input}"
  end

  def product_img_url(photo, size)
    url = photo ? photo.version(size) : "/assets/admin/no-image-#{size}.gif"
    "#{ActionController::Base.asset_host}#{url}"
  end

  private
  def add_mtime(input) # 加入修改时间querysting
    "#{ActionController::Base.asset_host}/#{input}?#{File.mtime(Rails.root.join('public', input)).to_i}"
  end

end
