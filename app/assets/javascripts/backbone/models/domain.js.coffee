App.Models.Domain = Backbone.Model.extend
  name: 'shop_domain'

App.Collections.Domains = Backbone.Collection.extend
  model: App.Models.Domain
  url: '/admin/domains'
