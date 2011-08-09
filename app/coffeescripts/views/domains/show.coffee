App.Views.Domain.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click a.btn": "make_primary"

  initialize: ->
    self = this
    this.render()
    $('#domains > .items').append @el
    @model.bind 'change', -> self.render()

  render: ->
    template = Handlebars.compile $('#domain-item').html()
    attrs = @model.attributes
    $(@el).html template attrs
    $(@el).addClass 'primary' if @model.get('primary')
    this.check_dns()

  check_dns: ->
    self = this
    $.get "/admin/domains/#{@model.id}/check_dns", (data) ->
      message = if data is 'ok' then '成功' else $('#dns-wiki-item').html()
      self.$('.dns-check').html message

  make_primary: ->
    self = this
    primary_domain = @collection.detect (model) -> model.get('primary')
    $.post "/admin/domains/#{@model.id}/make_primary", _method: 'put', (data) ->
      primary_domain.set primary: false
      self.model.set primary: true
    false
