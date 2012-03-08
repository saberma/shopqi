App.Views.Shipping.WeightBasedShippingRates.Show = Backbone.View.extend
  tagName: 'tr'

  initialize: ->
    @render()

  render: ->
    self = this
    template = Handlebars.compile $('#standard-rate-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    $('#standard-rate').append @el
