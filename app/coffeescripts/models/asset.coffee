Asset = Backbone.Model.extend
  name: 'asset'
  url: ->
    "/admin/assets/#{this.id}"
