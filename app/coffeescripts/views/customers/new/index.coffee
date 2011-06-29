App.Views.Customer.New.Index = Backbone.View.extend
  el: '#main'

  initialize: ->
    this.render()
    TagUtils.init()
    RegionUtils.init()

  render: ->
