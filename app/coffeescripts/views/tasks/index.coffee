App.Views.Task.Index = Backbone.View.extend
  el: '#sticky-progress'

  initialize: ->
    this.render()
    $("a[data-guide-target]").guide() # 新手指引

  render: ->
    self = this
    if current_guide?
      $('#task-checkoff').show()
      $('#progress-bar').hide()
    else
      $('#task-checkoff').hide()
      $('#progress-bar').show()
