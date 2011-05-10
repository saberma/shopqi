App.Views.ProductOption.Edit = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-option'

  events:
    "click .del-option": "destroy"

  initialize: ->
    this.render()

  render: ->
    $(this.el).html $('#optoin-item').tmpl this.model.attributes
    $('#add-option-bt').before this.el

  destroy: =>
    App.product_options.remove this.model
    this.remove()
    return false
