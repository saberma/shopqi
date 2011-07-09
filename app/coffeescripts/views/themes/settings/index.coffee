App.Views.Theme.Settings.Index = Backbone.View.extend
  el: '#main'

  events:
    "submit form": 'save'
    "change #theme_load_preset": 'load'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#section-header-item').html()
    $('fieldset').each ->
      title = $('legend', this).text()
      $(this).hide().before template title: title
    $('.section-header').addClass('collapsed').click ->
      $(this).toggleClass 'collapsed'
      $(this).next().toggle()
    $('.section-header:first').click()
    $('.color').miniColors()

    template = Handlebars.compile $('#theme-load-preset-item').html()
    _(settings.presets).each (value, name) -> $('#theme_load_preset').append template name: name

  save: ->
    attrs = _.reduce $('form').serializeArray(), (result, obj) ->
      result[obj.name] = obj.value
      result
    , {_method: 'put'}
    $.post "/admin/themes/settings", attrs, (data) ->

  load: ->
    preset = $('#theme_load_preset').children('option:selected').val()
    _(settings.presets[preset]).each (value, name) ->
      obj = $("##{name}")
      switch obj.attr('type')
        when 'checkbox'
          obj.attr 'checked', value
        else
          obj.val value
          obj.trigger 'keyup.miniColors' if obj.hasClass 'color' # 更新颜色指示方块
