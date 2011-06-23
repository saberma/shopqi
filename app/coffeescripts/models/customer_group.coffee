CustomerGroup = Backbone.Model.extend
  name: 'customer'
  url: ->
    "/admin/customer_groups/#{this.id}"
