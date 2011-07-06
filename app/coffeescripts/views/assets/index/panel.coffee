App.Views.Asset.Index.Panel = Backbone.View.extend
  el: '#current-asset'

  events:
    "click #open-button": 'open'
    "click #save-button": 'save'
    "click #asset-link-rollback a": 'versions'
    "click #asset-rollback-form a": 'cancelRollback'
    "change #asset-rollback-form select": 'updateAsset'
    "click #asset-link-rename a": 'showRename'
    "click #asset-rename-form a.update": 'rename'
    "click #asset-rename-form a.cancel": 'cancelRename'
    "click #asset-link-destroy a": 'destroy'

  initialize: ->
    self = this
    this.render()

  render: ->

  open: ->
    window.open("/admin/themes/assets/0/edit", "_blank", "menubar=no,location=no,resizable=yes,scrollbars=yes,status=no,width=900,height=700")

  save: ->
    model = TemplateEditor.current
    value = TemplateEditor.editor.getSession().getValue()
    $('#asset-info').html("正在保存 #{model.get('name')} &hellip;").show()
    $.post '/admin/themes/assets/0', key: model.get('key'), value: value, _method: 'put', ->
      $('#asset-info').html("您的文件已经保存.").fadeOut(5000)
      model.view.setModified false

  versions: ->
    model = TemplateEditor.current
    $.get '/admin/themes/assets/0/versions', key: model.get('key'), (data) ->
      template = Handlebars.compile $('#rollback-selectbox-item').html()
      $('#asset-link-rollback').replaceWith template commits: data
    false

  updateAsset: ->
    model = TemplateEditor.current
    tree_id = $('#asset-rollback-form select').children('option:selected').attr('tree_id')
    $.get "/admin/themes/assets/#{tree_id}", key: model.get('key'), (data) ->
      editor = TemplateEditor.editor
      editor.getSession().setValue data
      editor.moveCursorTo(0,0)
    false

  showRename: -> # 显示重命名表单
    model = TemplateEditor.current
    $('#asset-link-rename').replaceWith $('#asset-rename-form-item').html()
    $('#asset-basename-field').val(model.get('name')).focus()
    false

  rename: -> # 重命名
    self = this
    model = TemplateEditor.current
    basename = $('#asset-basename-field').val()
    new_key = model.get('key').replace model.get('name'), basename
    attrs = key: model.get('key'), new_key: new_key, _method: 'put'
    $.post '/admin/themes/assets/0/rename', attrs, ->
      model.set key: new_key, name: basename
      self.cancelRename()
    false

  cancelRename: ->
    $('#asset-rename-form').replaceWith $('#asset-link-rename-item').html()
    false

  destroy: ->
    self = this
    model = TemplateEditor.current
    if confirm("您确定要删除#{model.get('name')}吗?")
      attrs = key: model.get('key'), _method: 'delete'
      $.post "/admin/themes/assets/0", attrs, (data) ->
        $('#asset-buttons, #asset-info').hide()
        $('#asset-title').text('没有选择文件')
        $('#asset-links').css('visibility', 'hidden').html ''
        $('#asset-hint, #asset-hint-noselect').show()
        $('#asset-hint-liquid').hide()
        $('#template-editor').hide()
        msg "#{model.get('key')} 已经删除"
        model.view.remove()
        TemplateEditor.current = null
    false

  cancelRollback: ->
    $('#asset-rollback-form').replaceWith $('#asset-link-rollback-item').html()
    false
