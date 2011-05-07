App.Views.CustomCollection.Product = Backbone.View.extend
  tagName: 'li'
  className: 'clear'

  events:
    "click .remove-product": "destroy"

  initialize: ->
    _.bindAll this, 'render', 'destroy'
    $(this.el).attr 'id', "product_#{this.model.id}"
    this.render()

  render: ->
    self = this
    $(this.el).html $('#product_item').tmpl this.model.attributes
    $('#products').append this.el

  destroy: ->
    App.custom_collection_products.remove(this.model)
    $(this.el).remove()
    available_product = App.available_products.get(this.model.attributes.product_id)
    $(available_product.view.el).removeClass('added')
    return false
