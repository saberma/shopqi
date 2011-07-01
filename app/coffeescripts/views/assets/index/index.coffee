App.Views.Asset.Index.Index = Backbone.View.extend
  el: '#main'

  #events:
  #  "change .selector": 'changeCustomerCheckbox'

  initialize: ->
    self = this
    this.render()

  render: ->
    _(@options.data).each (assets, name) ->
      collection = new App.Collections.Assets assets
      collection.each (asset) -> new App.Views.Asset.Index.Show model: asset, name: name
