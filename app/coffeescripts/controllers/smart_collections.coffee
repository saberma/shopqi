App.Controllers.SmartCollections = Backbone.Controller.extend

  routes:
    "smart_collections/edit":      "edit"
    "":                            "index"

  edit: (id) ->
    $('.page-edit').show()
    $('#page-show').hide()

  index: ->
    $('.page-edit').hide()
    $('#page-show').show().bind 'click', ->
      window.location = '#pages/edit'
