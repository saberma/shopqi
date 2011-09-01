App.Models.Asset = Backbone.Model.extend
  name: 'asset'
  url: ->
    "/admin/assets/#{this.id}"

  extension: ->
    postfix = this.get('name').split('.')[1]
    postfix.toLowerCase() if postfix?

App.Collections.Assets = Backbone.Collection.extend
  model: App.Models.Asset

