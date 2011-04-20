App.Controllers.LinkLists = Backbone.Controller.extend
  initialize: ->
    this.index()

  routes:
    "link_lists/:id/edit":      "edit"
    "new":                      "newOne"

  edit: (id) ->
    model = App.link_lists.get(id)
    if model
      new App.Views.LinkList.Edit
        model: model
        el: $("#edit_form_link_container_link_list_#{model.id}")

  index: ->
    App.link_lists = new App.Collections.LinkLists
    App.link_lists.fetch
      success: ->
        new App.Views.LinkList.Index collection: App.link_lists
      #error: ->
      #  new Error message: "加载列表时发生错误."

  newOne: ->
    new App.Views.LinkList.New
