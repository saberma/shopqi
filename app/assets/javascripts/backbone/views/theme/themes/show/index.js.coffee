App.Views.Theme.Themes.Show.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    self = this
    this.render()
    $("a.fancy-box").fancybox()
    $("a.login").fancybox ajax: {
      success: (href, data, textStatus) ->
        if data is 'logged' # 已登录
          window.location = href
        else if data is 'from_admin' # 后台管理中进入主题商店，则不需要显示登录窗口
          form = document.createElement("form")
          form.setAttribute("action", "/themes/login/authenticate")
          form.setAttribute("method", "post")
          form.submit()
        false # 不弹出窗口
    }

  render: ->
    template = Handlebars.compile $('#overview-item').html()
    attrs = @model.clone_attributes()
    $('#overview').html template attrs
    template = Handlebars.compile $('#screenshots-item').html()
    $('#screenshots').html template id: @model.id
    new App.Views.Theme.Themes.Show.Style
    new App.Views.Theme.Themes.Show.Other
