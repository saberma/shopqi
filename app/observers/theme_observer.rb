class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_create(shop)
    shop.theme = 'prettify'
    FileUtils.cp_r shop.app_theme, shop.public_theme
  end

  def after_destroy(shop)
    FileUtils.rm_rf shop.public_theme
  end
end

class Shop

  def app_theme
    File.join Rails.root, 'app', 'themes', self.theme.to_s
  end

  def public_theme
    test = (Rails.env == 'test') ? 'test' : '' #测试目录与其他环境分开,不干扰
    shop_theme = File.join Rails.root, 'public', 'themes', test, self.id.to_s
  end

  def layout_theme
    File.join public_theme, 'layout', 'theme.liquid'
  end

  def template_theme(template)
    File.join public_theme, 'templates', "#{template}.liquid"
  end

end
