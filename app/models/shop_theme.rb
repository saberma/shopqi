# encoding: utf-8
#商店外观主题
class ShopTheme < ActiveRecord::Base
  belongs_to :shop
  belongs_to :theme
  has_many :settings, class_name: 'ShopThemeSetting', dependent: :destroy

  validates_presence_of :load_preset

  before_validation do
    # 初始化主题设置
    self.load_preset = config_settings['current']
  end

  after_save do
    FileUtils.mkdir_p public_path
    FileUtils.cp_r "#{app_path}/.", public_path
    config_settings['presets'].each_pair do |preset, values|
      values.each_pair do |name, value|
        self.settings.create name: name, value: value
      end
    end
  end

  def switch(new_theme)
    self.update_attribute :theme, new_theme
  end

  def app_path
    File.join Rails.root, 'app', 'themes', self.theme.name.downcase
  end

  def files_relative_path
    test = (Rails.env == 'test') ? 'test' : '' #测试目录与其他环境分开,不干扰
    File.join 's', 'files', test, self.id.to_s, 'theme'
  end

  def public_path
    File.join Rails.root, 'public', files_relative_path
  end

  def asset_relative_path(asset)
    File.join files_relative_path, 'assets', asset
  end

  def asset_path(asset)
    asset_liquid = "#{asset}.liquid"
    path = File.join public_path, 'assets', asset_liquid
    if File.exist?(path) #存在liquid文件，则解释liquid
      path
    else
      File.join public_path, 'assets', asset
    end
  end

  def layout_theme_path
    File.join public_path, 'layout', 'theme.liquid'
  end

  def template_path(template)
    File.join public_path, 'templates', "#{template}.liquid"
  end

  def config_settings_path
    File.join app_path, 'config', 'settings.html'
  end

  def config_settings_data_path #script/theme.rb将保证此文件存在
    File.join app_path, 'config', 'settings_data.json'
  end

  def config_settings
    JSON(File.read(config_settings_data_path))
  end
end

# 外观主题设置
class ShopThemeSetting < ActiveRecord::Base
  belongs_to :theme, class_name: 'ShopTheme'
end
