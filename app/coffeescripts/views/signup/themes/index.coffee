App.Views.Signup.Theme.Index = Backbone.View.extend
  el: '#signup'

  events:
    'click #show-more-themes': 'more' # 更多主题
    'click #current-theme a': 'show' # 挑选其他主题
    'click #theme-hint a': 'skip' # 跳过这一步

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    i = 0
    @collection.each (model) ->
      view = new App.Views.Signup.Theme.Show model: model
      where = if i++ < 4 then 'initial-themes' else 'more-themes'
      $("##{where}").prepend view.el

  more: -> # 显示更多主题
    $('#more-themes').slideDown()
    $('#show-more-themes').hide()
    false

  show: -> # 显示主题列表
    $("#themes-section").slideDown()
    $('#current-theme').fadeOut('slow')
    $("#selected-theme").val ''
    false

  skip: -> # 跳过这一步
    $("#initial-themes li:first .next").click()
    false
