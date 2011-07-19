# encoding: utf-8
# 可选外观主题(使用ActiveHash，以后增加记录直接加item，无须增加migration)
class Theme < ActiveYaml::Base
  COLOR = %w(red yellow green blue magenta white black grey)
  set_root_path "#{Rails.root}/app/models"

  def self.default
    find_by_name('Threadify')
  end

  begin 'oauth2' # theme作为client，向provider请求认证时传递的返回跳转uri
    def self.redirect_uri
      url = "http://themes.#{Setting.domain.url}"
      url += ":#{Setting.domain.port}" unless Setting.domain.port == 80
      "#{url}/callback"
    end

    def self.client_id
      client.client_id
    end

    def self.client_secret
      client.client_secret
    end

    def self.client
      OAuth2::Model::ConsumerClient.where(name: 'themes').first
    end
  end
end
Theme.all # Fixed: NoMethodError: undefined method `find_by_name_and_style' for Theme:Class
