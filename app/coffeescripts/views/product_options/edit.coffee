App.Views.ProductOption.Edit = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-option'

  events:
    "click .del-option": "destroy"

  initialize: ->
    _.bindAll this, 'destroy'
    @model.view = this
    this.render()

  render: ->
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'even' else 'odd'
    $(@el).addClass cycle
    attrs = _.clone @model.attributes
    attrs['destroyable'] = position isnt 0
    $(@el).html $('#option-item').tmpl attrs
    $('#add-option-bt').before @el

  destroy: ->
    App.product_options.remove @model
    return false
