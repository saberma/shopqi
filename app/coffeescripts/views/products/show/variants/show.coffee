App.Views.Product.Show.Variant.Show = Backbone.View.extend
  tagName: 'li'

  events:
    "submit form": "save"
    "click .selector": "updateList"
    "click .edit-btn": "edit"
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'edit'
    $(@el).attr 'id', "variant_#{@model.id}"
    this.render()
    $('#variants-list').append @el

  save: ->
    self = this
    @model.save FormUtils.to_h(this.$('form')),
      success: (model, resp) ->
        self.render()
        #修改成功!
        msg '\u4FEE\u6539\u6210\u529F\u0021'
        self.cancel()
    false

  render: ->
    index = _.indexOf @model.collection.models, @model
    cycle = if index % 2 == 0 then 'odd' else 'even'
    $(@el).html $('#show-variant-item').tmpl @model.attributes
    this.$('.inventory-row').addClass cycle
    this.$("input.requires_shipping").change()
    this.$("select.inventory_management").val(@model.attributes.inventory_management)
    this.$("select.inventory_management").change()
    this.$("select.inventory_management").change()
    this.$("input[name='product_variant[inventory_policy]'][value='#{@model.attributes.inventory_policy}']").attr('checked', true)

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
