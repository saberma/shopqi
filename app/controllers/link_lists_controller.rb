class LinkListsController < ApplicationController
  layout 'admin'

  expose(:link_lists)
  expose(:link_list)
  expose(:link_types) { LinkType.all }
  expose(:link)

  def index
  end

  def create
    link_list = LinkList.create! params[:link_list]
    render :json => link_list
  end
end
