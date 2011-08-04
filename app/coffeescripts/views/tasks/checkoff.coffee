App.Views.Task.Checkoff = Backbone.View.extend
  el: '#task-checkoff'

  events:
    "click #complete-task-button": "complete" # 完成任务
    "click #skip-task-button": "skip" # 选择其他任务

  initialize: ->
    this.render()

  render: ->
    name = @model.get('name')
    incomplete_tasks = @collection.select (model) -> !model.get('completed')
    template = Handlebars.compile $("#checkoff-item").html()
    $(@el).html template name: this.step_name(), incomplete_task_count: (incomplete_tasks.length - 1) # 除去launch任务
    template = Handlebars.compile $("##{name}-desc-item").html()
    this.$('.desc').html template

  complete: ->
    self = this
    $('#complete-task-button').addClass 'task-checked'
    next_task = @collection.get(@model.id + 1)
    $.post "/admin/dashboard/complete_task/#{@model.get('name')}", ->
      self.model.set completed: true
      $(self.el).fadeOut 500, ->
        $('#progress-bar').fadeIn 500, ->
          $.guide $("##{next_task.get('name')}"), self.next_step_message(next_task), 'top'
    false

  skip: ->
    $(@el).fadeOut 500, ->
      $('#progress-bar').fadeIn 500

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

  step_name: ->
    switch @model.get('name')
      when 'add_product'
        '增加一个商品'
      when 'customize_theme'
        '外观设置'
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
