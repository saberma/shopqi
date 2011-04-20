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
    App.link_lists.create title: this.$("input[name='link_list[title]']").val()
    return false

  cancel: ->
    $(this.el).hide()
    $('#link_list_title').blur()
