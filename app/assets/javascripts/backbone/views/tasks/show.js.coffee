App.Views.Task.Show = Backbone.View.extend
  tagName: 'li'

  initialize: ->
    self = this
    @model.view = this # 与checkoff.coffee交互
    this.render()
    $(@el).attr 'id', @model.get('name')
    $('#progress-bar ul').append @el
    @model.bind 'change:completed', (model) -> self.render()

  render: ->
    name = @model.get('name')
    template = Handlebars.compile $("##{name}-item").html()
    attrs = _.clone @model.attributes
    attrs['is_current'] = @model is @options.current_task
    $(@el).html template attrs
    state = if @model.get('completed') then 'completed' else 'incomplete'
    $(@el).addClass(name).addClass state
    this.$("a[data-guide-target]").guide() # 完成任务后重新render，显示下一步的提示
