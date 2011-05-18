App.Views.Product.Show.Variant.Index = Backbone.View.extend

  el: '#variant-inventory'

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()
    $(@el).delegate ".selector", 'change', ->
      if self.$('.selector:checked')[0]
        $('#product-controls').show()
      else
        $('#product-controls').hide()

  render: ->
    $('#variants-list').html('')
    $('#row-head').html $('#row-head-item').tmpl()
    _(@collection.models).each (model) ->
      new App.Views.Product.Show.Variant.Show model: model
