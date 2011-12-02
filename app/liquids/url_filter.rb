module UrlFilter

  def asset_url(input)
    shop = @context['shop'] #ShopDrop
    "#{asset_host_for_shop}#{shop.asset_url(input)}"
  end

  def global_asset_url(input)
    add_mtime "s/global/#{input}"
  end

  def shopqi_asset_url(input)
    add_mtime "s/shopqi/#{input}"
  end

  def product_img_url(photo, size)
    url = photo ? photo.version(size) : "/assets/admin/no-image-#{size}.gif"
    "#{asset_host_for_shop}#{url}"
  end

  private
  def add_mtime(input) # 加入修改时间querysting
    "#{asset_host_for_shop}/#{input}?#{File.mtime(Rails.root.join('public', input)).to_i}"
  end

  def asset_host_for_shop
    asset_host = ActionController::Base.asset_host # 可能为Proc对象
    asset_host.respond_to?(:call) ? asset_host.call : asset_host
  end

end
