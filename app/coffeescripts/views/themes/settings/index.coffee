App.Views.Theme.Settings.Index = Backbone.View.extend
  el: '#main'

  events:
    "submit form": 'save'
    "change #settings_panel :input": 'customize' # 修改配置项左边选项切换至'定制'
    "change #save-current-setting": 'select' # 点击复选框显示新增命名
    "change #theme_save_preset_existing": 'select_existing'

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    template = Handlebars.compile $('#section-header-item').html()
    $('fieldset').each ->
      title = $('legend', this).text()
      $(this).hide().before template title: title
    $('.section-header').addClass('collapsed').click ->
      $(this).toggleClass 'collapsed'
      $(this).next().toggle()
    $('.section-header:first').click()
    $('.color').miniColors()
    $('.miniColors').live 'mousedown', (e) -> self.customize(e) # fixed: 修改颜色要修改预设选项
    @presets_view = new App.Views.Theme.Settings.Preset.Index

  save: ->
    self = this
    attrs = _.reduce $('form').serializeArray(), (result, obj) ->
      result[obj.name] = obj.value
      result
    , {_method: 'put'}
    $.post "/admin/themes/settings", attrs, (data) ->
      msg '保存成功!'
      collection = self.presets_view.collection
      new_preset_name = $('#theme_save_preset_new').val()
      exist_preset_name = $('#theme_save_preset_existing').val()
      if $('#save-current-setting').attr('checked') # 名称要先保存到变量，此操作会清空名称
        $('#save-current-setting').attr('checked', false).change()
      if new_preset_name
        collection.add name: new_preset_name, value: data
        $('#theme_load_preset').val new_preset_name
      else if exist_preset_name
        preset = collection.detect (model) -> model.get('name') is exist_preset_name
        preset.set value: data
        $('#theme_load_preset').val exist_preset_name

  customize: (e) -> # 修改配置项，切换至定制预设
    $('#theme_load_preset').val '' if e.target.type not in ['submit', 'file']

  select: -> # 显示新增命名输入项
    checked = $('#save-current-setting').attr 'checked'
    $('#save-preset').toggle(checked)
    $('#theme_save_preset_existing').val('').change()

  select_existing: -> # 显示或隐藏名称输入项
    existing =  $('#theme_save_preset_existing').val() is ''
    $('#theme_save_preset_new_container').toggle(existing)
    $('#theme_save_preset_new').val ''
