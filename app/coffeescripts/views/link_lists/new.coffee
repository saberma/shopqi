App.Views.LinkList.New = Backbone.View.extend
  el: '#add-menu'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.model = new LinkList
    $(this.el).show()
    $('#link_list_title').focus()

  save: ->
    self = this
    this.model.save {title: this.$('#link_list_title').val()}
      success: (model, resp) ->
        $(self.el).hide()
        $('#link_list_title').val ''
        new App.Views.LinkList.Show model: model
        Backbone.history.saveLocation "link_lists/#{model.id}"
      error: () ->
        new App.Views.Error
    return false

  cancel: ->
    $(this.el).hide()
