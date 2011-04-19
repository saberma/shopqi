class LinkListsController < ApplicationController
  layout 'admin'

  expose(:link_lists) { LinkList.all }
  expose(:link_list)
  expose(:link_types) { LinkType.all }
  expose(:link)

  def index
    respond_to do |format|
      format.html
      format.json  { render :json => link_lists}
    end
  end

  def create
    link_list = LinkList.create! params[:link_list]
    render :json => link_list
  end
end
