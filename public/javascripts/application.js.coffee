App =
  Views:
    LinkList: {}
  Controllers: {},
  init: () ->
    new App.Controllers.LinkLists()
    Backbone.history.start()
