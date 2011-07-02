App.Views.Asset.Index.Show = Backbone.View.extend
  tagName: 'li'
  className: 'file'

  events:
    "click a": 'show'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $("#theme-item").html()
    attrs = @model.attributes
    attrs['type'] = @model.extension()
    $(@el).html template attrs
    $("#theme-#{@options.name}").append @el

  show: ->
    self = this
    $('#theme-editor-sidebar-top .current-file').removeClass('current-file')
    $(@el).addClass('current-file')
    $('#asset-buttons').show()
    $('#asset-title').text(@model.get('name')).show()
    $('#asset-info').show()
    $('#asset-links').css('visibility', 'visible')
    $('#asset-hint').hide()
    $('#asset-rollback-form').hide()
    $('#asset-link-rename').hide()
    $('#asset-rename-form').hide()
    $('#asset-link-destroy').hide()
    unless TemplateEditor.editor?
      editor = ace.edit("template-editor")
      editor.setTheme 'ace/theme/clouds'
      TemplateEditor.editor = editor
    $.get "/admin/themes/asset/#{@model.get('id')}", (data) ->
      editor = TemplateEditor.editor
      session = editor.getSession()
      extension = self.model.extension()
      mode = if extension in ['css', 'js'] then "#{extension}_mode" else 'html_mode'
      session.setMode new TemplateEditor[mode]
      session.setValue data
      session.setUseSoftTabs true
      editor.moveCursorTo(0,0)
    false
