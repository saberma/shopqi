class App.Models.Task extends Backbone.Model
  name: 'shop_task'

App.Collections.Tasks = Backbone.Collection.extend
  model: App.Models.Task
