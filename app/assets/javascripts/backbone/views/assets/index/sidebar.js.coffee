# 新增处理
App.Views.Asset.Index.Sidebar = Backbone.View.extend
  el: '#theme-editor-sidebar-top'

  events:
    "click #new_layout_reveal_link a": 'addLayout'
    "click #new-layout a": 'cancelLayout'
    "click #new_layout_btn": 'saveLayout'
    "click #new_template_reveal_link a": 'addTemplate'
    "click #new-template a": 'cancelTemplate'
    "click #new_template_btn": 'saveTemplate'
    "click #new_snippet_reveal_link a": 'addSnippet'
    "click #new-snippet a": 'cancelSnippet'
    "click #new_snippet_btn": 'saveSnippet'
    "click #new_asset_reveal_link a": 'addAsset'
    "click #new-asset a": 'cancelAsset'
    "click #new_asset_btn": 'saveAsset'

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    uploader = new qq.FileUploader
      multiple: false
      element: $('#file-uploader')[0],
      action: "/admin/themes/#{theme_id}/assets/0/upload"
      onSubmit: (id, file_name) ->
        $('#indicator').show()
        $(document).mousemove window.moveIndicator
        csrf_token = $('meta[name=csrf-token]').attr('content')
        csrf_param = $('meta[name=csrf-param]').attr('content')
        this.params = key: "assets/#{file_name}", name: file_name
        this.params[csrf_param] = csrf_token
      onComplete: (id, file_name, responseJSON)->
        $('#indicator').hide()
        $(document).unbind 'mousemove'
        self.options.assets.assets.add responseJSON
    $('.qq-upload-list').hide() # 不显示上传文件列表
    $(".qq-upload-button").contents().first().replaceWith("选择文件")

  saveLayout: ->
    self = this
    source = $('#new-layout-selectbox').children('option:selected')
    [source_key, source_name] = [source.val(), source.text()]
    name = $('#new_layout_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = source_key.replace source_name, name
    attrs = key: key, source_key: source_key
    $.post "/admin/themes/#{theme_id}/assets", attrs, (data) ->
      self.options.assets.layout.add key: key, name: name
      self.cancelLayout()

  addLayout: ->
    $('#new_layout_reveal_link').hide()
    template = Handlebars.compile $('#new-layout-selectbox-item').html()
    $('#new-layout-selectbox').html template layouts: @options.data.layout
    $('#new-layout').show()
    $('#new_layout_basename_without_ext').focus()
    false

  cancelLayout: ->
    $('#new_layout_reveal_link').show()
    $('#new-layout').hide()
    $('#new_layout_basename_without_ext').val ''
    false

  saveTemplate: ->
    self = this
    source = $('#new-template-selectbox').children('option:selected')
    unless source[0]
      error_msg '没有候选模板!'
      return
    [key, name] = ["templates/#{source.val()}.liquid", "#{source.text()}.liquid"]
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    $.post "/admin/themes/#{theme_id}/assets", key: key, (data) ->
      self.options.assets.templates.add key: key, name: name
      self.cancelTemplate()

  addTemplate: ->
    self = this
    options = $('#new-template-selectbox').children('option').map -> $(this).text() # 迭代的同时不能修改Option节点，得分两步
    _(options).each (name) ->
      value = "#{name}.liquid"
      created = self.options.assets.templates.detect (model) -> model.get('name') is value
      option = $('#new-template-selectbox').children("option[value='#{name}']")
      option.toggle(!created).attr('disabled', created)
    $('#new-template-selectbox').val $('#new-template-selectbox').children('option:enabled:first').val()
    $('#new_template_reveal_link').hide()
    $('#new-template').show()
    false

  cancelTemplate: ->
    $('#new_template_reveal_link').show()
    $('#new-template').hide()
    false

  saveSnippet: ->
    self = this
    name = $('#new_snippet_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = "snippets/#{name}"
    $.post "/admin/themes/#{theme_id}/assets", key: key, (data) ->
      self.options.assets.snippets.add key: key, name: name
      self.cancelSnippet()

  addSnippet: ->
    self = this
    $('#new_snippet_reveal_link').hide()
    $('#new-snippet').show()
    $('#new_snippet_basename_without_ext').focus()
    false

  cancelSnippet: ->
    $('#new_snippet_reveal_link').show()
    $('#new-snippet').hide()
    $('#new_snippet_basename_without_ext').val ''
    false

  saveAsset: ->
    self = this
    name = $('#new_asset_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = "assets/#{name}"
    $.post "/admin/themes/#{theme_id}/assets", key: key, (data) ->
      self.options.assets.assets.add key: key, name: name
      self.cancelAsset()

  addAsset: ->
    self = this
    $('#new_asset_reveal_link').hide()
    $('#new-asset').show()
    $('#new_asset_basename_without_ext').focus()
    false

  cancelAsset: ->
    $('#new_asset_reveal_link').show()
    $('#new-asset').hide()
    $('#new_asset_basename_without_ext').val ''
    false
