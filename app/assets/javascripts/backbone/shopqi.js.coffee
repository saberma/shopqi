#=require_self
#=require ./models/theme
#=require ./controllers/theme/themes/index
#=require_tree ./views/signup
#=require_tree ./views/theme/themes

window.App =
  Views:
    Signup:
      Theme: {}
    Theme:
      Themes:
        Index: {}
        Show: {}
  Controllers:
    Themes: {}
    Theme:
      Themes: {}
  Collections: {}
  Models: {}
  init: ->

$(document).ready ->
  App.init()
