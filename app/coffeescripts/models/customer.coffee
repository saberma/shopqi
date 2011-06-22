Customer = Backbone.Model.extend
  name: 'customer'
  url: ->
    "/admin/customers/#{this.id}"
