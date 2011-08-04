App.Views.Task.Index = Backbone.View.extend
  el: '#sticky-progress'

  initialize: ->
    this.render()
    $("a[data-guide-target]").guide() # 新手指引

  render: ->
    self = this
    @collection.each (model) -> new App.Views.Task.Show model: model
    if task_name?
      task = @collection.detect (model) -> model.get('name') is task_name
      unless task.get('completed')
        new App.Views.Task.Checkoff model: task, collection: @collection
        $('#task-checkoff').show()
        $('#progress-bar').hide()
        return
    $('#task-checkoff').hide()
    $('#progress-bar').show()
