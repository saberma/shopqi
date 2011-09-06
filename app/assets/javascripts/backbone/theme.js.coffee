#=require_self
#=require ./controllers/theme/themes/index
#=require ./models/theme
#=require_tree ./views/theme/themes
window.App =
  Views:
    Theme:
      Themes:
        Index: {}
        Show: {}
  Controllers:
    Theme:
      Themes: {}
  Collections: {}
  Models: {}
  init: ->

$(document).ready ->
  App.init()
