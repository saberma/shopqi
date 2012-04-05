App.Models.Discount = Backbone.Model.extend
  name: 'discount'

App.Collections.Discounts = Backbone.Collection.extend
  model: App.Models.Discount
  url: '/admin/discounts'
