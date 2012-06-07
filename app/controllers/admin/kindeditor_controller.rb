class Admin::KindeditorController < Admin::AppController
  prepend_before_filter :authenticate_user!
  expose(:shop) { current_user.shop }

  #用于处理kindeditor图片上传
  def upload_image
    @image = shop.kindeditors.build(kindeditor_image: params[:imgFile])
    if @image.save
      render text: {error: 0, url: @image.url}.to_json
    else
      render  text: {error: 1, message: @image.errors.full_messages.join(',')}.to_json
    end
  end

end
