App.Collections.Links = Backbone.Collection.extend
  model: Link
  #init by link_lists
  #url: '/admin/link_lists/:link_list_id/links'

  initialize: ->
    _.bindAll this, 'addOne'
    this.bind 'add', this.addOne

  addOne: (model, collection) ->
    #新增成功!
    msg '\u65B0\u589E\u6210\u529F\u0021'
    $('#add-menu').hide()
    $('#link_list_title').val ''
    new App.Views.LinkList.Show model: model
    Backbone.history.saveLocation "link_lists/#{model.id}"
