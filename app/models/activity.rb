class Activity < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user

  def self.log(record,operate,user,content = "")
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
    Activity.create operate: operate,class_name: class_name, user: user, shop: user.try(:shop),content: content
  end

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

end
