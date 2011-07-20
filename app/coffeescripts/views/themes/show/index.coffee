App.Views.Theme.Show.Index = Backbone.View.extend
  el: '#wrapper'

  initialize: ->
    self = this
    this.render()
    $("a.fancy-box").fancybox()
    $("a.login").fancybox ajax: {
      success: (href, data, textStatus) ->
        if data is 'logged'
          window.location = href
          false # 不弹出窗口
    }

  render: ->
    template = Handlebars.compile $('#overview-item').html()
    attrs = @model.clone_attributes()
    $('#overview').html template attrs
    template = Handlebars.compile $('#screenshots-item').html()
    $('#screenshots').html template id: @model.id
    new App.Views.Theme.Show.Style
    new App.Views.Theme.Show.Other
