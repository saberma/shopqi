App.Views.LinkList.New = Backbone.View.extend
  events:
    "submit form": "save"

  initialize: () ->
    $('#add-menu').show()

  save: () ->
    self = this
    this.model.save title: this.$('[name=title]').val(), ->
      success: (model, resp) ->
        self.model = model
        new App.Views.LinkList.Show(model: model)
        Backbone.history.saveLocation('link_lists/' + model.id)
      error: () ->
        new App.Views.Error()
      return false
