# encoding: utf-8
# 可选外观主题
class Theme < ActiveRecord::Base
  COLOR = %w(red yellow green blue magenta white black grey)

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
