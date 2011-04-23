# encoding: utf-8
class LinkListsController < ApplicationController
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
    link_list.save
    render :json => link_list
  end
end
