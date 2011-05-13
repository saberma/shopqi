App.Views.Product.Show.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #action-links a.edit-btn": "toggleEdit"

  initialize: ->
    new App.Views.Product.Show.Show model: @model
    new App.Views.Product.Show.Edit model: @model
    @model.bind 'change:title', ->
      $('#product_title > a').text self.attributes.title

  toggleEdit: ->
    $('#product-edit').toggle()
    $('#product-right-col').toggle()
    $('#product').toggle()
    false
