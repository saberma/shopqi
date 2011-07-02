Asset = Backbone.Model.extend
  name: 'asset'
  url: ->
    "/admin/assets/#{this.id}"

  extension: ->
    postfix = this.get('name').split('.')[1]
    postfix.toLowerCase() if postfix?
