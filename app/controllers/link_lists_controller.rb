# encoding: utf-8
class LinkListsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:link_lists) { LinkList.all }
  expose(:link_list)
  expose(:link_types) { LinkType.all }
  expose(:link)

  def index
  end

  def create
    link_list.save
    render :json => link_list
  end

  def destroy
    link_list.destroy
    render :json => link_list
  end

  def update
    links = params[:link_list].delete(:links)
    link_list.links_attributes = links
    link_list.save
    render :json => link_list
  end
end
