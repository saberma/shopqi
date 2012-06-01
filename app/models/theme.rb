# encoding: utf-8
# 可选外观主题
class Theme < ActiveRecord::Base
  COLOR = %w(red yellow green blue magenta white black grey)
  mount_uploader :file      , ThemeUploader
  mount_uploader :main      , ThemeMainUploader
  mount_uploader :collection, ThemeCollectionUploader
  mount_uploader :product   , ThemeProductUploader
  attr_accessible :name, :handle, :style, :style_handle, :role, :price, :color, :desc, :shop, :site, :author, :email, :published, :file, :main, :collection, :product, :position

  validates_presence_of :name, :handle, :style, :style_handle, :role, :color
  validates_uniqueness_of :style_handle, scope: :handle

  default_value_for :style       , '默认'
  default_value_for :style_handle, 'default'
  default_value_for :role        , KeyValues::Theme::Role.first.code
  default_value_for :color       , COLOR.first

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

    def self.client_name
      'themes'
    end

    def self.client_id
      client.uid
    end

    def self.client_secret
      client.secret
    end

    def self.client_redirect_uri
      "http://themes.#{Setting.host}#{':4000' if development?}/callback"
    end

    def self.client
      Doorkeeper::Application.find_by_name(self.client_name)
    end

  end

end
