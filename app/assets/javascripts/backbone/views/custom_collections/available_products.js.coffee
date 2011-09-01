App.Views.CustomCollection.AvailableProducts = Backbone.View.extend

  el: '#browse-view'

  events:
    "submit form": "search"

  search: ->
    self = this
    $.getJSON "/admin/custom_collections/available_products", q: @$("input[name='q']").val(), (data)->
      self.$('.small-collection > .candidate').remove()
      App.available_products.refresh(data)
    return false
