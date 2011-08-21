# encoding: utf-8
class LinkList < ActiveRecord::Base
  belongs_to :shop
  has_many :links, dependent: :destroy, order: :position.asc

  accepts_nested_attributes_for :links
end

class Link < ActiveRecord::Base
  belongs_to :link_list

  def url
    shop = link_list.shop
    case link_type
    when 'blog'
      blog = shop.blogs.find(subject_id)
      "/blogs/#{blog.handle}"
    when 'frontpage'
      "/"
    when 'collection'
      collection = shop.custom_collections.find(subject_id)
      "/collections/#{collection.handle}"
    when 'page'
      page = shop.pages.find(subject_id)
      "/pages/#{page.handle}"
    when 'product'
      product = shop.products.find(subject_id)
      "/products/#{product.handle}"
    when 'search'
      "/search"
    when 'http'
      "#{subject}"
    end
  end
end
