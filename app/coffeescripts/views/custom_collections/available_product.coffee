App.Views.CustomCollection.AvailableProduct = Backbone.View.extend
  tagName: 'li'
  className: 'candidate tiny-with-thumb'

  events:
    "click .title": "addToCollection"

  initialize: ->
    _.bindAll this, 'render', 'addToCollection'
    $(this.el).attr 'id', "possible-product-#{this.model.id}"
    this.render()

  render: ->
    self = this
    $(this.el).html $('#available_product_item').tmpl this.model.attributes
    $('#product-select > .small-collection').append this.el

  addToCollection: ->
    $(this.el).addClass('added')
    App.products.add this.model
    return false
