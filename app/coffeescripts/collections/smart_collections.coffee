App.Collections.SmartCollections = Backbone.Collection.extend
  model: SmartCollection
  url: '/admin/smart_collections'

  initialize: ->
    _.bindAll this, 'addOne'
    this.bind 'add', this.addOne

  addOne: (model, collection) ->
    model.with_links()
    #新增成功!
    msg '\u65B0\u589E\u6210\u529F\u0021'
    $('#add-menu').hide()
    $('#smart_collection_title').val ''
    new App.Views.SmartCollection.Show model: model
    Backbone.history.saveLocation "smart_collections/#{model.id}"
