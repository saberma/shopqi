App.Views.Discount.New = Backbone.View.extend
  el: '#new-code'

  events:
    "submit form": "save"
    "click .cancel": "cancel"
    "click #generate-coupon-code": "generate"

  initialize: ->
    self = this
    @model = new App.Models.Discount
    @collection = App.discounts
    @collection.bind 'add', (model, collection) ->
      self.cancel()
      msg '新增成功!'
      new App.Views.Discount.Show model: model
      $('#none-item').hide()# 有记录了不显示"无记录"提示 
    $('#discount_code').focus()

  save: ->
    @collection.create code: @$("#discount_code").val(), value: @$("#discount_value").val(), usage_limit: @$("#discount_usage_limit").val()
    false

  cancel: ->
    $(@el).hide()
    $('#discount_code').val('').blur()
    false

  generate: ->
    $('#discount_code').val Utils.randomString(8)
    false
