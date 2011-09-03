App.Views.LinkList.New = Backbone.View.extend
  el: '#add-menu'

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    @model = new LinkList
    @collection = App.link_lists
    @collection.bind 'add', (model, collection) ->
      model.with_links()
      self.cancel()
      msg '新增成功!'
      new App.Views.LinkList.Show model: model
    $('#list_title').focus()

  save: ->
    @collection.create title: this.$("#list_title").val()
    false

  cancel: ->
    $(@el).hide()
    $('#list_title').val('').blur()
    false
