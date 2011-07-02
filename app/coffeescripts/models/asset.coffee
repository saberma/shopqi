Asset = Backbone.Model.extend
  name: 'asset'
  url: ->
    "/admin/assets/#{this.id}"

  extension: ->
    this.get('name').split('.')[1]
