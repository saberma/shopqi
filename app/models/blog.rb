#encoding: utf-8
class Blog < ActiveRecord::Base
  include Models::Handle
  has_many :articles, dependent: :destroy, order: 'id desc'
  belongs_to :shop
  validates_presence_of :title
  attr_accessible :title, :handle, :commentable

  before_save do
    self.make_valid(shop.blogs)
  end

  def comments_enabled?
    commentable != 'no'
  end

  searchable do
    integer :shop_id, references: Shop
    text :title
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
  has_many :unapproved_comments,class_name:"Comment",conditions:"comments.status = 'pending'"
  #垃圾评论
  has_many :spam_comments,class_name:"Comment",conditions:"comments.status = 'spam'"
  validates_presence_of :title
  delegate :shop, to: :blog
  attr_accessible :title, :body_html, :published, :author

  searchable do
    integer :shop_id, references: Shop
    text :title, :body_html
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

  def self.show(id)
    self.where(id: id, published: true).first
  end

end

#文章评论
class Comment < ActiveRecord::Base
  belongs_to :article
  has_one    :blog, through: :article
  belongs_to :shop
  validates_presence_of :body,:email,:author
  validates :email, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
  attr_accessible :status, :author, :email, :body

  before_create do
    self.shop_id = article.shop_id
  end
end
