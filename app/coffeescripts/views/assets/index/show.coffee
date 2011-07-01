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
    unless $('#template-editor').hasClass('ace_editor')
      ace.edit("template-editor")
    $('#asset-buttons').show()
    $('#asset-title').text(@model.get('name')).show()
    $('#asset-info').show()
    $('#asset-links').css('visibility', 'visible')
    $('#asset-hint').hide()
    $('#asset-rollback-form').hide()
    $('#asset-link-rename').hide()
    $('#asset-rename-form').hide()
    $('#asset-link-destroy').hide()
    false
