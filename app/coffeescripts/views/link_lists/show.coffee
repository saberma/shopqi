App.Views.LinkList.Show = Backbone.View.extend
  initialize: () ->
    this.render()

  render: () ->
    $(this.el).html $('#show-menu').tmpl this.model.attributes
    $('#menus').append this.el
