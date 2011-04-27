App.Controllers.SmartCollections = Backbone.Controller.extend
  initialize: ->
    this.index()

  routes:
    "smart_collections/:id/edit":      "edit"
    "new":                             "newOne"

  edit: (id) ->
    model = App.smart_collections.get(id)
    if model
      new App.Views.SmartCollection.Edit
        model: model
        el: $("#edit_form_link_container_smart_collection_#{model.id}")

  index: ->
    new App.Views.SmartCollection.Index collection: App.smart_collections

  newOne: ->
    new App.Views.SmartCollection.New
