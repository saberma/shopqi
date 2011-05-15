App.Views.Product.Show.Variant.Show = Backbone.View.extend
  tagName: 'li'

  events:
    "click .selector": "updateList"

  initialize: ->
    _.bindAll this, 'render'
    $(@el).attr 'id', "variant_#{@model.id}"
    this.render()

  render: ->
    self = this
    $(@el).html $('#show-variant-item').tmpl @model.attributes
    $('#variants-list').append @el

  # 显示或隐藏操作面板
  updateList: ->
