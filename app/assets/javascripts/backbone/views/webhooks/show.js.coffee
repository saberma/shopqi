App.Views.Webhook.Show = Backbone.View.extend
  tagName: 'tr'
  className: 'webhook-subscription'

  events:
    "click .destroy": "destroy"

  initialize: ->
    @render()

  render: ->
    template = Handlebars.compile $('#webhook-item').html()
    $(@el).html template @model.attributes
    $('#add-webhook').before @el

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      @model.destroy
        success: (model, response) ->
          App.webhooks.remove self.model
          self.remove()
          msg '删除成功!'
    false
