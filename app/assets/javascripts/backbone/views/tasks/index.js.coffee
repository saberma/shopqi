App.Views.Task.Index = Backbone.View.extend
  el: '#sticky-progress'

  initialize: ->
    this.render()
    $("a[data-guide-target]").guide() # 新手指引

  render: ->
    self = this
    current_task = @collection.detect (model) -> !model.get('completed')
    @collection.each (model) -> new App.Views.Task.Show model: model, current_task: current_task
    if task_name? # 当前页面关联任务(变量在各个页面中定义)
      task = @collection.detect (model) -> model.get('name') is task_name
      unless task.get('completed')
        new App.Views.Task.Checkoff model: task, collection: @collection
        $('#task-checkoff').show()
        $('#progress-bar').hide()
        return
    $('#task-checkoff').hide()
    $('#progress-bar').show()
