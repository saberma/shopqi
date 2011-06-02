#encoding: utf-8
class PhotosController < ApplicationController
  expose(:product)
  expose(:photos){ product.photos}
  expose(:photo)

  def destroy
    photo.destroy
    flash[:notice] = notice_msg
    respond_to do |format|
      format.js
    end
  end
end
