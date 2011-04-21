class LinkListsController < ApplicationController
  prepend_before_filter :authenticate_user!
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
