App.Controllers.Pages = Backbone.Controller.extend

  routes:
    "pages/edit":      "edit"
    "":                "index"

  edit: ->
    $('.page-edit').show()
    $('#page-show').hide()

  index: ->
    $('.page-edit').hide()
    $('#page-show').show().bind 'click', ->
      window.location = '#pages/edit'
