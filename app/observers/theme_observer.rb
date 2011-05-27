class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_create(shop)
    shop.theme = 'prettify'
    theme = File.join Rails.root, 'app', 'themes', shop.theme.to_s
    shop_theme = File.join Rails.root, 'public', 'themes', shop.id.to_s
    FileUtils.cp_r theme, shop_theme
  end

  def after_destroy(shop)
    shop_theme = File.join Rails.root, 'public', 'themes', shop.id.to_s
    FileUtils.rm_rf shop_theme
  end
end
