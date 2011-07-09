App.Views.Theme.Settings.Index = Backbone.View.extend
  el: '#main'

  events:
    "submit form": 'save'
    "change #theme_load_preset": 'load'
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
    template = Handlebars.compile $('#theme-load-preset-item').html() # 预设下拉选项
    _(settings.presets).each (value, name) ->
      option = template name: name
      $('#theme_load_preset').append option
      $('#theme_save_preset_existing').append option
    if _.isString settings.current
      $('#theme_load_preset').val(settings.current).change()
    else
      this.loadSettings settings.current

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

  load: -> # 加载预设至右边配置项
    preset = $('#theme_load_preset').children('option:selected').val()
    this.loadSettings settings.presets[preset]

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

  # private
  loadSettings: (settings_hash) -> # 加载配置项
    _(settings_hash).each (value, name) ->
      obj = $("##{name}")
      switch obj.attr('type')
        when 'checkbox'
          obj.attr 'checked', value
        else
          obj.val value
          obj.trigger 'keyup.miniColors' if obj.hasClass 'color' # 更新颜色指示方块
