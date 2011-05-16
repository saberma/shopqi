#encoding: utf-8
class Blog < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  validates_presence_of :title
  #默认的handle等于title 
  before_save do 
    self.handle = self.title unless self.handle
  end
end

#博客文章
class Article < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user
  has_many :comments, dependent: :destroy
  #公开的评论　
  has_many :published_comments,class_name:"Comment", conditions:"comments.status = 'published'"
  #待审核评论
  has_many :unapproved_comments,class_name:"Comment",conditions:"comments.status = 'unapproved'"
  #已删除评论
  has_many :removed_comments,class_name:"Comment",conditions:"comments.status = 'removed'"
end

#文章评论
class Comment < ActiveRecord::Base
  belongs_to :article
end

