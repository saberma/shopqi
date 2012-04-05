App.Views.Discount.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #add-discount-code-link": "add"

  initialize: ->
    @render()
    new App.Views.Discount.New

  render: ->
    @collection.each (model) -> new App.Views.Discount.Show model: model
    $('#none-item').show() if _.isEmpty(@collection.models)

  add: ->
    $('#new-code').show()
    $('#discount_code').focus()
    false
