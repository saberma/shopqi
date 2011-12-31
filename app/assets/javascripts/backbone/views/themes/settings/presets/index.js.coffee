App.Views.Theme.Settings.Preset.Index = Backbone.View.extend
  el: '#presets'

  events:
    "change #theme_load_preset": 'load'
    "click #delete_theme_preset_link": 'destroy' # 删除

  initialize: ->
    @collection = new App.Collections.Presets
    @collection.bind 'add', (model) -> new App.Views.Theme.Settings.Preset.Show model: model
    @collection.bind 'remove', (model) -> model.view.destroy()
    @render()

  render: ->
    self = this
    _(settings_json.presets).each (value, name) -> self.collection.add name: name, value: value
    if _.isString settings_json.current
      $('#theme_load_preset').val(settings_json.current)
    else
      @loadSettings settings_json.current
    $('#theme_load_preset').change()

  load: -> # 加载预设至右边配置项
    name = $('#theme_load_preset').children('option:selected').val()
    preset = @collection.detect (model) -> model.get('name') is name
    @loadSettings preset.get('value') if preset
    @showDelete() # 显示删除按钮

  # private
  loadSettings: (settings_hash) -> # 加载配置项
    _(settings_hash).each (value, name) ->
      obj = $("##{name}")
      switch obj.attr('type')
        when 'checkbox'
          obj.attr 'checked', value
        when 'radio'
          $("input[name='settings[#{name}]'][value='#{value}']").attr('checked', 'checked')
        else
          obj.val value
          obj.trigger 'keyup.miniColors' if obj.hasClass 'color' # 更新颜色指示方块

  destroy: ->
    self = this
    name = $('#theme_load_preset').children('option:selected').val()
    if confirm('您确定要删除此预设吗?')
      $.post '/admin/themes/#{theme_id}/delete_preset', name: name, ->
        msg '删除成功!'
        preset = self.collection.detect (model) -> model.get('name') is name
        self.collection.remove preset
    false

  showDelete: ->
    customized = $('#theme_load_preset').val() is ''
    $('#delete_theme_preset_link').toggle !customized
