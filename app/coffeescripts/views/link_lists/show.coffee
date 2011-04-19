App.Views.LinkList.Show = Backbone.View.extend
  initialize: () ->
    this.render()

  render: () ->
    compiled = _.template $('#show-menu').html()
    $(this.el).html compiled this.model.toJSON()
    $('#menus').append this.el
