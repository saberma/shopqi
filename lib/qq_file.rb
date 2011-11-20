# encoding: utf-8
# 支持ie7浏览器上传 http://j.mp/rYClMJ
# qqfile = QqFile.new(params[:qqfile], request)
class QqFile

  def initialize(qqfile, request)
    @qqfile  = qqfile
    @request = request
  end

  def body
    ie_upload? ? @qqfile.read : @request.raw_post
  end

  def name
    ie_upload? ? @qqfile.original_filename : @qqfile
  end

  def ie_upload? # IE上传时qqfile为ActionDispatch::Http::UploadedFile
    !@qqfile.is_a? String
  end

end
