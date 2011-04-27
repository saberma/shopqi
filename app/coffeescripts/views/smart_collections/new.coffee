App.Views.SmartCollection.New = Backbone.View.extend
  el: '#add-menu'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.model = new SmartCollection
    $(this.el).show()
    $('#smart_collection_title').focus()

  save: ->
    App.smart_collections.create title: this.$("input[name='smart_collection[title]']").val()
    return false

  cancel: ->
    $(this.el).hide()
    $('#smart_collection_title').blur()
