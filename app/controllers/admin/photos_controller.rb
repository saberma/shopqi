#encoding: utf-8
class Admin::PhotosController < Admin::AppController
  prepend_before_filter :authenticate_user!
  expose(:product)
  expose(:photos){ product.photos}
  expose(:photo)

  def destroy
    photo.destroy
    flash.now[:notice] = notice_msg
    respond_to do |format|
      format.js
    end
  end

  def create
    position = photos.blank? ? 0 : photos.last.position + 1 # 注意:一调用photo，则photos就包含photo对象了
    photo.position = position
    photo.save
    flash[:notice] = notice_msg
    redirect_to product_path(product)
  end

  def sort
    params[:photo].each_with_index do |id, index|
      product.photos.find(id).update_attributes :position => index
    end
    render js: "markFeaturedImage()"
  end
end
