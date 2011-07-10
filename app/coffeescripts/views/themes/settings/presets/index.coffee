App.Views.Theme.Settings.Preset.Index = Backbone.View.extend
  el: '#presets'

  events:
    "change #theme_load_preset": 'load'

  initialize: ->
    @collection = new App.Collections.Presets
    @collection.bind 'add', (model) -> new App.Views.Theme.Settings.Preset.Show model: model
    this.render()

  render: ->
    self = this
    _(settings.presets).each (value, name) -> self.collection.add name: name, value: value
    if _.isString settings.current
      $('#theme_load_preset').val(settings.current).change()
    else
      this.loadSettings settings.current

  load: -> # 加载预设至右边配置项
    name = $('#theme_load_preset').children('option:selected').val()
    preset = @collection.detect (model) -> model.get('name') is name
    this.loadSettings preset.get('value')

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
