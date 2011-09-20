#=require "backbone/models/shop_theme"
App.Views.Theme.Show = Backbone.View.extend
  tagName: 'li'
  tagClass: 'clearfix'

  events:
    'click .publish-theme-link a'     : 'publish'
    'click .duplicate-theme a'        : 'duplicate'
    'click .delete-theme a'           : 'destroy'
    'click .publish-theme-dropdown a' : 'cancel'
    'submit form'                     : 'save'

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

  duplicate: ->
    self = this
    btn = @$('.duplicate-theme a')
    unless btn.hasClass('disabledrow')
      @$('.duplicate-theme a').addClass('disabledrow')
      $.post "/admin/themes/#{@model.id}/duplicate", (data) ->
        App.unpublished_themes.add data
        self.$('.duplicate-theme a').removeClass('disabledrow')
    false

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      collection = @model.collection
      @model.destroy
        success: (model, response) ->
          self.remove()
          collection.remove self.model
          msg '删除成功!'
    false

  save: ->
    $.post "/admin/themes/#{@model.id}", 'theme[role]': @$("select[name='theme[role]']").val(), _method: 'put', ->
      window.location = window.location # 刷新页面

  cancel: ->
    @$('.publish-theme-link').show()
    @$('.publish-theme-dropdown').hide()
    false
