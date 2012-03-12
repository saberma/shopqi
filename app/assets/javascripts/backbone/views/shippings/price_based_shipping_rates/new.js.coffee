App.Views.Shipping.PriceBasedShippingRates.New = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"
    "click .show-max-purchase a"    : "showMaxPurchase" # 显示价格的终止区间
    "blur .edit-max-purchase input" : "hideMaxPurchase" # 隐藏价格的终止区间

  initialize: ->
    self = this
    @collection.bind 'add', (model, collection) ->
      self.cancel()
      msg "新增成功!"
      show = new App.Views.Shipping.PriceBasedShippingRates.Show model: model, collection: self.collection
      $(show.el).effect 'highlight', {}, 2000

  save: ->
    self = this
    @collection.create
      name: @$("input[name='name']").val()
      min_order_subtotal: @$("input[name='min_order_subtotal']").val()
      max_order_subtotal: @$("input[name='max_order_subtotal']").val()
      price: @$("input[name='price']").val()
    false

  cancel: ->
    $(@el).hide()
    false

  showMaxPurchase: ->
    @$('.show-max-purchase').hide()
    @$('.edit-max-purchase').show()
    @$('.edit-max-purchase input').focus()
    false

  hideMaxPurchase: ->
    unless @$('.edit-max-purchase input').val()
      @$('.edit-max-purchase').hide()
      @$('.show-max-purchase').show()
    false
