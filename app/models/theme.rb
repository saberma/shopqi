# encoding: utf-8
# 可选外观主题
class Theme < ActiveRecord::Base
  COLOR = %w(red yellow green blue magenta white black grey)
  mount_uploader :file      , ThemeUploader
  mount_uploader :main      , ThemeMainUploader
  mount_uploader :collection, ThemeCollectionUploader
  mount_uploader :product   , ThemeProductUploader

  after_destroy do #删除对应的目录
    FileUtils.rm_rf self.path
  end

  def self.default
    self.first
  end

  def path
    File.join Rails.root, 'data', 'themes', self.id.to_s, 'current'
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
