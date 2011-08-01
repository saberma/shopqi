# encoding: utf-8
class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_destroy(shop)
    FileUtils.rm_rf shop.theme.public_path
  end
end
