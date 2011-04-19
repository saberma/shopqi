App.Views.LinkList.Index = Backbone.View.extend
  initialize: () ->
    this.link_lists = this.options.link_lists
    this.render()

  render: () ->
    _(this.link_lists).each (model) ->
      new App.Views.LinkList.Show model: model
