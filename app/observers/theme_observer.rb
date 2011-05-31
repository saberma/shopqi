class ThemeObserver < ActiveRecord::Observer
  observe :shop

  def after_create(shop)
    shop.create_theme(theme_id: Theme.default.id) unless shop.theme
    theme = shop.theme
    FileUtils.mkdir_p theme.public_path
    FileUtils.cp_r "#{theme.app_path}/.", theme.public_path
    # 初始化主题设置
    theme.config_settings.each_pair do |name, value|
      theme.settings.create name: name, value: value
    end
  end

  def after_destroy(shop)
    FileUtils.rm_rf shop.theme.public_path
  end
end
