App.Views.Theme.Settings.Preset.Show = Backbone.View.extend

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#theme-load-preset-item').html()
    option = template @model.attributes
    $('#theme_load_preset').append option
    $('#theme_save_preset_existing').append option
