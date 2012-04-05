App.Views.Discount.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .destroy": "destroy"

  initialize: ->
    @render()
    $('#coupons tbody').append @el

  render: ->
    template = Handlebars.compile $('#discount-item').html()
    attrs = _.clone @model.attributes
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass cycle
    $(@el).html template attrs

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.discounts.remove self.model
          self.remove()
          msg '删除成功!'
    return false
