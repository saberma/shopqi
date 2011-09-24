#=require "backbone/models/shop_theme"
#=require "fileuploader"
#=require "./list"
App.Views.Theme.Index = Backbone.View.extend
  el: '#main'

  events:
    'click #customer a'           : 'upload'
    'click #upload-theme .cancel' : 'cancel'

  initialize: ->
    @render()

  render: ->
    new App.Views.Theme.List el: '#published', collection: App.published_themes
    new App.Views.Theme.List el: '#unpublished', collection: App.unpublished_themes

  upload: ->
    self = this
    unless @uploader
      @uploader = new qq.FileUploader
        multiple: false
        element: $('#file-uploader')[0],
        action: "/admin/themes/upload"
        onSubmit: (id, file_name) ->
          $('#indicator').show()
          $(document).mousemove window.moveIndicator
          csrf_token = $('meta[name=csrf-token]').attr('content')
          csrf_param = $('meta[name=csrf-param]').attr('content')
          @params = {}
          @params[csrf_param] = csrf_token
        onComplete: (id, file_name, responseJSON)->
          $('#indicator').hide()
          $(document).unbind 'mousemove'
          if responseJSON['error_type']
            error_msg("上传失败，请确定上传的文件类型为zip压缩格式", 5000)
          else if responseJSON['missing']
            error_msg("上传失败，缺少 #{responseJSON['missing']}", 5000)
          else if responseJSON['id'] # 上传成功，校验通过
            self.cancel()
            $('#theme-progress-bar').show()
            template = Handlebars.compile $('#finished-dialog-item').html()
            $('#finished-dialog').html template responseJSON
            window.setTimeout ->
              self.check_status(responseJSON)
            , 5000
    $('.qq-upload-list').hide() # 不显示上传文件列表
    $(".qq-upload-button").contents().first().replaceWith("选择文件")
    $('#upload-theme').show()
    $('#theme-progress-bar').hide()
    $('#finished-dialog').hide()
    false

  cancel: ->
    $('#upload-theme').hide()
    false

  check_status: (data) -> # 每间隔5秒主题是否解压完成
    self = this
    $.get "/admin/themes/#{data['id']}/background_queue_status", (json) ->
      if json
        $('#theme-progress-bar').hide()
        $('#finished-dialog').show()
        App.unpublished_themes.add json
      else
        window.setTimeout ->
          self.check_status(data)
        , 5000
