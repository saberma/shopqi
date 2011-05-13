App.Views.Product.Show.Show = Backbone.View.extend
  el: '#product'

  initialize: ->
    _.bindAll this, 'render'
    this.render()
    @model.bind 'change', (model) =>
      this.render()

  render: ->
    $(@el).html $('#show-product-item').tmpl @model.attributes
