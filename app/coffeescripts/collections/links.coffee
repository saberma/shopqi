App.Collections.Links = Backbone.Collection.extend
  model: Link
  #init by link_lists
  #url: '/admin/link_lists/:link_list_id/links'

  comparator: (link) ->
    link.get("position")

  initialize: ->
    _.bindAll this, 'addOne'
    this.bind 'add', this.addOne

  addOne: (model, collection) ->
    #显示新增按钮、隐藏自己
    $("#add_link_control_link_list_#{model.attributes.link_list_id}").show()
    add_container = "#add_link_form_link_list_#{model.attributes.link_list_id}"
    $(add_container).hide()
    $("input[name='link[title]']", add_container).val ''
    self.$("input[name='link[subject]']", add_container).val ''
    new App.Views.Link.Show model: model
    Backbone.history.saveLocation "link/#{model.id}"
