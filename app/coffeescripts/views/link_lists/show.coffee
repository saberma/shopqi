App.Views.LinkList.Show = Backbone.View.extend
  initialize: () ->
    this.render()

  render: () ->
    $(this.el).html($('#show-menu').html())
    $('#menus').append(this.el)
