# encoding: utf-8
class LinksController < ApplicationController
  prepend_before_filter :authenticate_user!

  expose(:link_list)
  expose(:links) { link_list.links }
  expose(:link)

  def create
    link.save
    render :json => link
  end

  def destroy
    link.destroy
    render :json => link
  end

  def sort
    params[:link].each_with_index do |id, index|
      link_list.links.find(id).update_attributes :position => index
    end
    render :nothing => true
  end
end
