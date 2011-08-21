# encoding: utf-8
class LinkListsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:link_lists) { shop.link_lists }
  expose(:link_lists_json) { link_lists.to_json(except: [ :created_at, :updated_at ], include: :links) }
  expose(:link_list)
  expose(:link_types) { KeyValues::Link::Type.options }
  expose(:link)

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
