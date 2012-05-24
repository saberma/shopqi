#encoding: utf-8
class Activity < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user
  attr_accessible :operate, :content, :user_id, :class_name

  module Extension

    def log(record, operate, user, content = "")
      class_name = record.class.to_s.underscore
      unless operate == 'delete'
        if class_name == 'article'
          url = url_helpers.blog_article_path record.blog,record
        else
          url_method = "#{class_name}_path".to_sym
          url = url_helpers.send url_method, record
        end
        content = "<a href='#{url}'>#{record.title}</a>"
      else
        content = record.title
      end
      shop.activities.create operate: operate, class_name: class_name, user: user, content: content
    end

    def shop
      @association.owner
    end

  end

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  def user_name
    user ? user.name : '系统自动生成'
  end

end
