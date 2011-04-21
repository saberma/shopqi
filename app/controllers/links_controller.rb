# encoding: utf-8
class LinksController < ApplicationController
  expose(:link)

  def create
    link.save
    render :json => link
  end
end
