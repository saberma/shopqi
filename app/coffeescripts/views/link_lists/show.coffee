App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox default-menu link-list'

  initialize: ->
    _.bindAll this, 'render'
    this.render()

  render: ->
    $(this.el).attr 'id', "#link_lists/#{this.model.id}"
    $(this.el).html $('#show-menu').tmpl this.model.attributes
    $('#menus').append this.el
