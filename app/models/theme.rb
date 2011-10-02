# encoding: utf-8
# 可选外观主题
class Theme < ActiveRecord::Base
  COLOR = %w(red yellow green blue magenta white black grey)
  mount_uploader :file, ThemeUploader

  before_save do
    self.handle = Pinyin.t(self.name, '-') if self.handle.blank?
    self.style_handle = Pinyin.t(self.style, '-') if self.style_handle.blank?
  end

  def self.default
    find_by_handle('Threadify')
  end

  begin 'oauth2' # theme作为client，向provider请求认证时传递的返回跳转uri

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
