class App.Models.Application extends Backbone.Model
  name: 'application'

App.Collections.Applications = Backbone.Collection.extend
  model: App.Models.Application
  url: '/admin/applications'
