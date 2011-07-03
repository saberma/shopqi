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
    $('#asset-hint-liquid').toggle(this.is_liquid_asset())
    $('#asset-hint').toggle(this.is_liquid_asset())
    $('#asset-rollback-form').hide()
    $('#asset-link-rename').hide()
    $('#asset-rename-form').hide()
    $('#asset-link-destroy').hide()
    $('#asset-hint-noselect').hide()
    if this.is_text_asset()
      $('#template-editor').show()
      $("#preview-image").hide()
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
    else
      $('#template-editor').hide()
      if this.is_image_asset()
        $("#preview-image").show()
        url = @model.get('url')
        $("#preview-image-asset").attr 'src', url
        $("#preview-image-asset").parent('a').attr('href', url) if url?
    false

  is_text_asset: ->
    @model.extension() in TemplateEditor.text_extensions

  is_image_asset: ->
    @model.extension() in TemplateEditor.image_extensions

  is_liquid_asset: ->
    ends = '.liquid'
    str = @model.get('name')
    str.substring(str.length - ends.length) is ends
