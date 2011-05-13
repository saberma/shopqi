App.Views.Product.Show.Show = Backbone.View.extend
  el: '#product'

  initialize: ->
    _.bindAll this, 'render'
    this.render()
    @model.bind 'change', (model) =>
      this.render()

  render: ->
    attrs = _.clone @model.attributes
    attrs['tags'] = StringUtils.to_a attrs.tags_text
    $(@el).html $('#show-product-item').tmpl attrs
