# encoding: utf-8
class LinksController < ApplicationController
  expose(:link_list)
  expose(:links) { link_list.links }
  expose(:link)

  def create
    link.save
    render :json => link
  end
end
