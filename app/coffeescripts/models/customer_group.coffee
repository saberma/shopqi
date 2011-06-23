CustomerGroup = Backbone.Model.extend
  name: 'customer_group'
  url: ->
    "/admin/customer_groups/#{this.id}"
