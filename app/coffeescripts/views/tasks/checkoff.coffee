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
          $.guide $("##{next_task.get('name')}"), self.next_step_message(next_task), 'top'
    false

  next_step_message: (task) ->
    message = "下一步骤是 "
    name = task.get('name')
    desc = switch name
      when 'customize_theme'
        '定制您的主题设置'
      when 'add_content'
        '发布您的商店公告'
      when 'setup_payment_gateway'
        '设置支付网关'
      when 'setup_taxes'
        '设置税率'
      when 'setup_shipping'
        '设置物流'
      when 'setup_domain'
        '设置域名'
      when 'launch'
        '启用商店'
    "#{message} #{desc}"
