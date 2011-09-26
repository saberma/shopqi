class KindeditorController < Admin::AppController
  skip_before_filter :verify_authenticity_token

  #用于处理kindeditor图片上传
  def upload_image
    @image = Kindeditor.new(:kindeditor_image => params[:imgFile])
    if @image.save
      render :text => {"error" => 0, "url" => @image.kindeditor_image.url}.to_json
    else
      render  :text => {"error" => 1}
    end
  end
end
