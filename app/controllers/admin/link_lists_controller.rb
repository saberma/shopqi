# encoding: utf-8
class Admin::LinkListsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:link_lists) { shop.link_lists }
  expose(:link_lists_json) do
    link_lists.to_json({
      except: [ :created_at, :updated_at ],
      include: { links: { except: [ :created_at, :updated_at ]} }
    })
  end
  expose(:link_list)
  expose(:link_types) { KeyValues::Link::Type.options }
  expose(:link)
  expose(:blog_types) { shop.blogs.map{|blog| [blog.title, blog.handle]} }
  expose(:collection_types) { shop.custom_collections.map{|collection| [collection.title, collection.handle]} }
  expose(:page_types) { shop.pages.map{|page| [page.title, page.handle]} }
  expose(:product_types) { shop.products.map{|product| [product.title, product.handle]} }

  def index
  end

  def create
    link_list.save
    render json: link_list
  end

  def destroy
    link_list.destroy
    render json: link_list
  end

  def update
    link_list.save
    render json: link_list
  end
end
