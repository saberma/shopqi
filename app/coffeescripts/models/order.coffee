Order = Backbone.Model.extend
  name: 'order'
  url: ->
    "/admin/orders/#{this.id}"
