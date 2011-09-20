class App.Models.ShopTheme extends Backbone.Model
  name: 'shop_theme'

App.Collections.ShopThemes = Backbone.Collection.extend
  model: App.Models.ShopTheme
  url: '/admin/themes'
