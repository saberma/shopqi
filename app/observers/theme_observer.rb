# encoding: utf-8
class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_create(shop)
    shop.create_theme(theme_id: Theme.default.id)
  end

  def after_destroy(shop)
    FileUtils.rm_rf shop.theme.public_path
  end
end
