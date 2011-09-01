Domain = Backbone.Model.extend
  name: 'shop_domain'

App.Collections.Domains = Backbone.Collection.extend
  model: Domain
  url: '/admin/domains'
