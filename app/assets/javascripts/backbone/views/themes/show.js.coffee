#=require "backbone/models/shop_theme"
App.Views.Theme.Show = Backbone.View.extend
  tagName: 'li'
  tagClass: 'clearfix'

  events:
    'click .publish-theme-link a': 'publish'
    'click .publish-theme-dropdown a': 'cancel'
    'submit form': 'save'

  initialize: ->
    @render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = _.clone @model.attributes
    attrs['is_main'] = @model.get('role') is 'main'
    attrs['is_published'] = @model.get('role') isnt 'unpublished'
    $(@el).html template attrs
    parent = $(@options.parent)
    parent.show()
    $('ul.theme', parent).append @el

  publish: ->
    @$('.publish-theme-link').hide()
    @$('.publish-theme-dropdown').show()
    false

  save: ->
    #$.post "/admin/themes/#{@model.id}", _method: 'put', ->

  cancel: ->
    @$('.publish-theme-link').show()
    @$('.publish-theme-dropdown').hide()
    false
