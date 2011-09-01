App.Models.Customer = Backbone.Model.extend
  name: 'customer'
  url: ->
    "/admin/customers/#{this.id}"

App.Collections.Customers = Backbone.Collection.extend
  model: App.Models.Customer
