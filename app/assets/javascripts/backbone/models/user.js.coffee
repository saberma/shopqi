class User extends Backbone.Model
  name: 'user'

App.Collections.Users = Backbone.Collection.extend
  model: User
  url: '/admin/users'
