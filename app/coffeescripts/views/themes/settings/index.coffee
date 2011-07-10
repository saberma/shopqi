App.Views.Theme.Settings.Index = Backbone.View.extend
  el: '#main'

  events:
    "submit form": 'save'
    "change #settings_panel :input": 'customize'
    "change #save-current-setting": 'select'
    "change #theme_save_preset_existing": 'select_existing'

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
    $('.color').miniColors change: -> $(this).change() # fixed: input change event fail.
    new App.Views.Theme.Settings.Preset.Index

  save: ->
    attrs = _.reduce $('form').serializeArray(), (result, obj) ->
      result[obj.name] = obj.value
      result
    , {_method: 'put'}
    $.post "/admin/themes/settings", attrs, (data) ->
      #if $('#theme_save_preset_new').val()
      #  $('#theme_load_preset') $('#theme_save_preset_new').val()
      $('#save-current-setting').attr('checked', false).change()
      msg '保存成功!'

  customize: (e) -> # 修改配置项，切换至定制预设
    $('#theme_load_preset').val '' if e.target.type isnt 'file'

  select: -> # 命名预设
    checked = $('#save-current-setting').attr 'checked'
    $('#save-preset').toggle(checked)
    $('#theme_save_preset_existing').val('')

  select_existing: -> # 显示或隐藏名称输入项
    existing =  $('#theme_save_preset_existing').val() is ''
    $('#theme_save_preset_new_container').toggle(existing)
    $('#theme_save_preset_new').val ''
