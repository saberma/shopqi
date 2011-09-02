# encoding: utf-8
class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_destroy(shop)
    shop.themes.each do |theme|
      FileUtils.rm_rf theme.public_path
    end
  end
end
