App.Collections.LinkLists = Backbone.Collection.extend ->
  model: LinkList
  url: '/link_lists'

  index: () ->
    link_lists = new App.Collections.LinkLists()
    link_lists.fetch
      success: () ->
        new App.Views.Index(collection: link_lists)
      error: () ->
        new Error(message: "加载过程发生错误.")
