class LinkListsController < ApplicationController
  layout 'admin'

  expose(:link_lists)
  expose(:link_list)
  expose(:link_types) { LinkType.all }
  expose(:link)

  def index
  end
end
