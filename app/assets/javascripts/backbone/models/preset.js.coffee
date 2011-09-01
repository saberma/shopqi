App.Models.Preset = Backbone.Model.extend
  name: 'preset'

App.Collections.Presets = Backbone.Collection.extend
  model: App.Models.Preset
