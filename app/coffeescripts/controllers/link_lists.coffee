App.Controllers.LinkLists = Backbone.Controller.extend
  initialize: ->
    this.index()

  routes:
    "link_lists/:id/edit":      "edit"
    "new":                      "newOne"

  edit: (id) ->
    model = new LinkList(id: id)
    model.fetch
      success: (model, resp) ->
        new App.Views.LinkList.Edit model: model
      #therubyracer bug https://github.com/cowboyd/therubyracer/issues/61#comment_807995
      #error: () ->
      #  new Error(message: '找不到相应的记录.')
      #  window.location.hash = '#'

  index: ->
    link_lists = new App.Collections.LinkLists
    link_lists.fetch
      success: ->
        new App.Views.LinkList.Index collection: link_lists
      #error: ->
      #  new Error message: "加载列表时发生错误."

  newOne: ->
    new App.Views.LinkList.New
