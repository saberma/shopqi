#=require_self
#=require ./controllers/themes/index
#=require ./models/theme
#=require ./views/themes/show/index
#=require ./views/themes/show/style
#=require ./views/themes/show/other
#=require ./views/themes/index/show
#=require ./views/themes/index/index
window.App =
  Views:
    Theme:
      Index: {}
      Show: {}
  Controllers:
    Themes: {}
  Collections: {}
  Models: {}
  init: ->

$(document).ready ->
  App.init()
