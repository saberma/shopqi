App.Views.CustomCollection.AvailableProduct = Backbone.View.extend
  tagName: 'li'
  className: 'candidate tiny-with-thumb'

  events:
    "click .title": "addToCollection"

  initialize: ->
    _.bindAll this, 'render', 'addToCollection'
    $(this.el).attr 'id', "possible-product-#{this.model.id}"
    this.render()
    this.model.view = this

  render: ->
    self = this
    $(this.el).html $('#available_product_item').tmpl this.model.attributes
    $('#product-select > .small-collection').append this.el

  addToCollection: ->
    unless $(this.el).hasClass('added')
      $(this.el).addClass('added')
      App.custom_collection_products.add this.model
    return false
