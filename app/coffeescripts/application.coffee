App =
  Views:
    LinkList: {}
    Link: {}
  Controllers: {}
  Collections: {}
  init: ->
    new App.Controllers.LinkLists
    Backbone.history.start()

$(document).ready ->
  App.init()
