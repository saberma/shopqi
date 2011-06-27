Order = Backbone.Model.extend
  name: 'order'
  url: ->
    "/admin/orders/#{this.id}"

  financial_class: ->
    "o-#{this.get('financial_status')}"

  fulfill_class: ->
    switch this.get('fulfillment_status')
      when 'fulfilled' then 'o-fulfilled'
      when 'partial' then 'o-partial'
      when 'unshipped' then 'o-not-fulfilled'
