class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_create(shop)
    shop.theme = 'prettify'
    FileUtils.cp_r app_themes(shop), public_themes(shop)
  end

  def after_destroy(shop)
    FileUtils.rm_rf public_themes(shop)
  end

  def app_themes(shop)
    File.join Rails.root, 'app', 'themes', shop.theme.to_s
  end

  def public_themes(shop)
    test = (Rails.env == 'test') ? 'test' : '' #测试目录与其他环境分开,不干扰
    shop_theme = File.join Rails.root, 'public', 'themes', test, shop.id.to_s
  end
end
