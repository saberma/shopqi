App.Views.Link.Edit = Backbone.View.extend
  tagName: 'li'
  className: 'sl link link-edit'

  initialize: ->
    #显示列表、隐藏无ITEM的提示
    edit_link_list_container_id = "#edit_form_link_container_link_list_#{this.model.attributes.link_list_id}"
    $('.hint.padding', edit_link_list_container_id).hide()
    $('.st', edit_link_list_container_id).show()
    _.bindAll this, 'render'
    $(this.el).attr 'id', "link_edit_li_#{this.model.id}"
    this.render()
    $('.nobull.ssb', edit_link_list_container_id).append this.el

  render: ->
    index = _.indexOf this.model.collection.models, this.model
    cycle = if index % 2 == 0 then 'odd' else 'even'
    attrs = _.clone this.model.attributes
    attrs['index'] = index
    $(this.el).html $('#edit-link-menu').tmpl attrs
    $(this.el).addClass cycle
