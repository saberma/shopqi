App.Views.Shipping.WeightBasedShippingRates.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .del": "destroy"

  initialize: ->
    @render()

  render: ->
    self = this
    template = Handlebars.compile $('#standard-rate-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    $(@collection.view.el).append @el

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      @model.destroy
        success: (model, response) ->
          self.collection.remove self.model
          self.remove()
          msg '删除成功!'
    false
