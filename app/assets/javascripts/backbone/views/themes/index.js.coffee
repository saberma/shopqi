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
    $('.qq-upload-list').hide() # 不显示上传文件列表
    $(".qq-upload-button").contents().first().replaceWith("选择文件")
    $('#upload-theme').show()
    false

  cancel: ->
    $('#upload-theme').hide()
    false
