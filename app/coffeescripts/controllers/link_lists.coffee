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
    new App.Views.LinkList.Index collection: App.link_lists

  newOne: ->
    new App.Views.LinkList.New
