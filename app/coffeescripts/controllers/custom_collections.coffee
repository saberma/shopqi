App.Controllers.CustomCollections = Backbone.Controller.extend

  initialize: ->
    #手动排序
    $("#products").sortable handle: '.drag-handle', update: (event, ui) ->
      $.post $(this).attr('url'), $(this).sortable('serialize')
      $('#custom_collection_products_order').val('manual')

  routes:
    "edit":      "edit"
    "":          "index"

  edit: (id) ->
    $('#collection-edit').show()
    $('#collection-description').hide()

  index: ->
    # 显示候选商品列表
    new App.Views.CustomCollection.AvailableProducts collection: App.available_products
    $('#collection-edit').hide()
    $('#collection-description').show().bind 'click', ->
      window.location = '#edit'
