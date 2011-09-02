App.Views.CustomCollection.AvailableProduct = Backbone.View.extend
  tagName: 'li'
  className: 'candidate tiny-with-thumb'

  events:
    "click .title": "addToCollection"

  initialize: ->
    _.bindAll this, 'render', 'addToCollection'
    $(@el).attr 'id', "possible-product-#{@model.id}"
    @render()
    @model.view = this

  render: ->
    template = Handlebars.compile $('#available_product_item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    $(@el).addClass('added') if @model.addedTo(App.custom_collection_products)
    $('#product-select > .small-collection').append @el

  addToCollection: ->
    unless @model.addedTo(App.custom_collection_products)
      $(@el).addClass('added')
      App.custom_collection_products.create product_id: @model.id, position: App.custom_collection_products.length
    return false
