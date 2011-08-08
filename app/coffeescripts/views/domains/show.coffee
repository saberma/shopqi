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
