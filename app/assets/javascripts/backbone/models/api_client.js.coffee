class App.Models.ApiClient  extends Backbone.Model
  name: 'api_client'

App.Collections.ApiClients  = Backbone.Collection.extend
  model: App.Models.ApiClient
  url: '/admin/api_clients'
