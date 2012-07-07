App.Models.Webhook = Backbone.Model.extend
  name: 'webhook'

App.Collections.Webhooks = Backbone.Collection.extend
  model: App.Models.Webhook
  url: '/admin/webhooks'
