App.Views.ProductOption.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    this.render()

  render: ->
    self = this
    position = _.indexOf @model.collection.models, @model
    attrs = @model.attributes
    attrs['position'] = position + 1
    $(@el).html $('#show-option-item').tmpl attrs
    $('#product-options-list').append @el
