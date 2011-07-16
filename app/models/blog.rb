#encoding: utf-8
class Blog < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  belongs_to :shop
  validates_presence_of :title

  before_save do
    self.handle = Pinyin.t(self.title, '-') if self.handle.blank? # 新增时初始化handle
  end

  def comments_enabled?
    commentable != 'no'
  end

  define_index do
    has :shop_id
    indexes :title
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta #增量更新索引
  end
end

#博客文章
class Article < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags
  #公开的评论　
  has_many :published_comments,class_name:"Comment", conditions:"comments.status = 'published'"
  #待审核评论
  has_many :unapproved_comments,class_name:"Comment",conditions:"comments.status = 'unapproved'"
  #已删除评论
  has_many :removed_comments,class_name:"Comment",conditions:"comments.status = 'removed'"

  define_index do
    has :shop_id
    indexes :title
    indexes :body_html
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta #增量更新索引
  end

  # 标签
  attr_accessor :tags_text

  def tags_text
    @tags_text ||= tags.map(&:name).join(',')
  end

  def comments_count
    comments.size
  end

  before_create do
    self.shop_id = blog.shop_id #冗余商店ID，方便全文检索过滤
  end

  def url
    "/#{blog.handle}/#{id}"
  end

  after_save do
    article_tags = self.tags.map(&:name)
    # 删除tag
    (article_tags - Tag.split(tags_text)).each do |tag_text|
      tag = blog.shop.tags.where(name: tag_text,category: 2).first
      tags.delete(tag)
    end
    # 新增tag
    (Tag.split(tags_text) - article_tags).each do |tag_text|
      tag = blog.shop.tags.where(name: tag_text,category: 2).first
      if tag
        # 更新时间，用于显示最近使用过的标签
        tag.touch
      else
        tag = blog.shop.tags.create(name: tag_text,category: 2) unless tag
      end
      self.tags << tag
    end
  end

end

#文章评论
class Comment < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :body
end

