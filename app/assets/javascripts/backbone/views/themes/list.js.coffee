#=require "backbone/models/shop_theme"
#=require "./show"
App.Views.Theme.List = Backbone.View.extend

  initialize: ->
    self = this
    @render()
    @collection.bind 'add', (model, collection) -> # 复制主题时显示在未发布列表
      msg '新增成功!'
      new App.Views.Theme.Show model: model, parent: self.el

  render: ->
    self = this
    @collection.each (model) -> new App.Views.Theme.Show model: model, parent: self.el
