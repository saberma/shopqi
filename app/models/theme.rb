# encoding: utf-8
# 可选外观主题(使用ActiveHash，以后增加记录直接加item，无须增加migration)
class Theme < ActiveYaml::Base
  COLOR = %w(red yellow green blue magenta white black grey)
  set_root_path "#{Rails.root}/app/models"

  def self.default
    find_by_name('Threadify')
  end
end
Theme.all # Fixed: NoMethodError: undefined method `find_by_name_and_style' for Theme:Class
