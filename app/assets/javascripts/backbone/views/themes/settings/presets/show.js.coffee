App.Views.Theme.Settings.Preset.Show = Backbone.View.extend
  tagName: 'option'

  initialize: ->
    @model.view = this
    @render()

  render: ->
    name = @model.get('name')
    $(@el).val(name).text(name).appendTo('#theme_load_preset')
    $(@el).clone().appendTo('#theme_save_preset_existing')

  destroy: ->
    @remove()
    name = @model.get('name')
    $('#theme_save_preset_existing').children("option[value='#{name}']").eq(0).remove()
    $('#theme_load_preset').change()
