App =
  Views:
    LinkList: {}
  Controllers: {},
  Collections: {},
  init: ->
    new App.Controllers.LinkLists
    Backbone.history.start()

$(document).ready ->
  App.init()
