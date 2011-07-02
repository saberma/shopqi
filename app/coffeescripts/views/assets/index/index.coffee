App.Views.Asset.Index.Index = Backbone.View.extend
  el: '#main'

  #events:
  #  "change .selector": 'changeCustomerCheckbox'

  initialize: ->
    self = this
    this.render()
    window.TemplateEditor =
      editor: null
      html_mode: require("ace/mode/html").Mode
      css_mode: require("ace/mode/css").Mode
      js_mode: require("ace/mode/javascript").Mode

  render: ->
    _(@options.data).each (assets, name) ->
      collection = new App.Collections.Assets assets
      collection.each (asset) -> new App.Views.Asset.Index.Show model: asset, name: name
