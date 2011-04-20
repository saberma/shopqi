App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox default-menu link-list'

  initialize: ->
    _.bindAll this, 'render'
    this.model.bind 'change', this.render
    $(this.el).attr 'id', "link_lists/#{this.model.id}"
    this.render()
    $('#menus').append this.el

  render: ->
    $(this.el).html $('#show-menu').tmpl this.model.attributes
