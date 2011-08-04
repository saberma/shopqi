App.Views.Task.Checkoff = Backbone.View.extend
  el: '#task-checkoff'

  events:
    "click #complete-task-button": "complete"
    "click #skip-task-button": "skip"

  initialize: ->
    this.render()

  render: ->
    name = @model.get('name')
    incomplete_tasks = @collection.select (model) -> !model.get('completed')
    template = Handlebars.compile $("##{name}-checkoff-item").html()
    $(@el).html template name: name, incomplete_task_count: (incomplete_tasks.length - 1) # 除去launch任务

  complete: ->
    $('#complete-task-button').addClass 'task-checked'
    this.finish()

  skip: ->
    this.finish skip: true

  # private
  finish: (params) ->
    self = this
    next_task = @collection.get(@model.id + 1)
    $.post "/admin/dashboard/complete_task/#{@model.get('name')}", params, ->
      self.model.set completed: true
      $(self.el).fadeOut 500, ->
        $('#progress-bar').fadeIn 500, ->
          $.guide $("##{next_task.get('name')}"), "下一步骤是 #{next_task.get('name')}", 'top'
    false
