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
    attrs['type'] = @model.get('name').split('.')[1]
    $(@el).html template attrs
    $("#theme-#{@options.name}").append @el

  show: ->
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
    unless $('#template-editor').hasClass('ace_editor')
      editor = ace.edit("template-editor")
      HtmlMode = require("ace/mode/html").Mode
      CssMode = require("ace/mode/css").Mode
      JavaScriptMode = require("ace/mode/javascript").Mode
      editor.getSession().setMode(new HtmlMode())
      editor.getSession().setMode(new CssMode())
      editor.getSession().setMode(new JavaScriptMode())
      $('#template-editor').data 'editor', editor
    $.get "/admin/themes/asset/#{@model.get('id')}", (data) ->
      editor = $('#template-editor').data 'editor'
      editor.getSession().setValue data
      editor.getSession().setUseSoftTabs(true)
      editor.moveCursorTo(0,0)
    false
