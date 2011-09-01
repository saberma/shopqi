class Task extends Backbone.Model
  name: 'shop_task'

App.Collections.Tasks = Backbone.Collection.extend
  model: Task
