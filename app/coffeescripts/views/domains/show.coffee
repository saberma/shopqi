App.Views.Domain.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    this.render()

  render: ->
    self = this
    template = Handlebars.compile $('#domain-item').html()
    attrs = @model.attributes
    $(@el).html template attrs
    $(@el).addClass 'primary' if @model.get('primary')
    $('#domains > .items').append @el
    this.check_dns()

  check_dns: ->
    self = this
    $.get "/admin/domains/#{@model.id}/check_dns", (data) ->
      message = if data is 'ok' then '成功' else $('#dns-wiki-item').html()
      self.$('.dns-check').html message
