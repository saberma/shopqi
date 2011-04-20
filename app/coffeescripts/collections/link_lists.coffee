App.Collections.LinkLists = Backbone.Collection.extend
  model: LinkList
  url: '/admin/link_lists'

  initialize: ->
    _.bindAll this, 'addOne'
    this.bind 'add', this.addOne

  addOne: (model, collection) ->
    $('#add-menu').hide()
    $('#link_list_title').val ''
    new App.Views.LinkList.Show model: model
    Backbone.history.saveLocation "link_lists/#{model.id}"
