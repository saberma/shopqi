App.Controllers.Orders.Index = Backbone.Controller.extend

  initialize: ->
    # 列表页面的查询条件：状态、支付状态、打包状态
    $('#status-filter-link').click ->
      $('#order-status-select
 > .dropdown').toggle()
      $('#payment-status-select > .dropdown').hide()
      $('#shipping-status-select > .dropdown').hide()
      false

    $('#payment-filter-link').click ->
      $('#order-status-select
 > .dropdown').hide()
      $('#payment-status-select > .dropdown').toggle()
      $('#shipping-status-select > .dropdown').hide()
      false

    $('#shipping-filter-link').click ->
      $('#order-status-select
 > .dropdown').hide()
      $('#payment-status-select > .dropdown').hide()
      $('#shipping-status-select > .dropdown').toggle()
      false

    # 选择页码
    $('#page-size-select').change ->
      document.location.href = $(this).val()

    $(document).click ->
      $('.dropdown').hide()

  routes:
    "nothing":      "nothing"
