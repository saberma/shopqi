class App.Models.User extends Backbone.Model
  name: 'user'

App.Collections.Users = Backbone.Collection.extend
  model: App.Models.User
  url: '/admin/users'
