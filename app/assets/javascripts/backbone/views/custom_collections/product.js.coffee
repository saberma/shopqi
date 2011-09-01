App.Views.CustomCollection.Product = Backbone.View.extend
  tagName: 'li'
  className: 'clear'

  events:
    "click .remove-product": "destroy"

  initialize: ->
    _.bindAll this, 'render', 'destroy'
    $(@el).attr 'id', "product_#{@model.id}"
    @render()

  render: ->
    template = Handlebars.compile $('#product_item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    $('#products').append @el

  destroy: ->
    self = this
    @model.destroy
      success: (model, response) ->
        App.custom_collection_products.remove(self.model)
        available_product = App.available_products.get(self.model.attributes.product_id)
        $(available_product.view.el).removeClass('added')
        self.remove()
    return false
