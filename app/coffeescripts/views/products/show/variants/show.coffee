App.Views.Product.Show.Variant.Show = Backbone.View.extend
  tagName: 'li'

  events:
    "click .selector": "updateList"
    "click .edit-btn": "edit"
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'edit'
    $(@el).attr 'id', "variant_#{@model.id}"
    this.render()

  render: ->
    self = this
    $(@el).html $('#show-variant-item').tmpl @model.attributes
    $('#variants-list').append @el

  # 显示或隐藏操作面板
  updateList: ->

  edit: ->
    $('#row-head').css opacity: 0.5
    this.$('.inventory-row').hide()
    this.$('tr.row-edit-details').show()
    this.$('tr.inventory_row').hide()
    false

  cancel: ->
    $('#row-head').removeAttr('style')
    this.$('.inventory-row').show()
    this.$('tr.row-edit-details').hide()
    this.$('tr.inventory_row').show()
    false
