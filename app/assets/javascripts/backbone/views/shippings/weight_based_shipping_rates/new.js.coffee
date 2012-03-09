App.Views.Shipping.WeightBasedShippingRates.New = Backbone.View.extend
  el: '#new-standard-rate'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    @collection.bind 'add', (model, collection) ->
      self.cancel()
      msg "新增快递费用成功."
      show = new App.Views.Shipping.WeightBasedShippingRates.Show model: model
      $(show.el).effect 'highlight', {}, 2000

  save: ->
    self = this
    @collection.create
      name: @$("input[name='name']").val()
      weight_low: @$("input[name='weight_low']").val()
      weight_high: @$("input[name='weight_high']").val()
      price: @$("input[name='price']").val()
    false

  cancel: ->
    $(@el).hide()
    false
