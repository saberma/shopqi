App.Controllers.Customers.Index = Backbone.Controller.extend

  initialize: ->
    # 选择页码
    $('#page-size-select').change ->
      document.location.href = $(this).val()

  routes:
    "nothing":      "nothing"
