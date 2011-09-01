#=require_self
#=require ./models/theme
#=require ./views/signup/themes/show
#=require ./views/signup/themes/index
#=require ./views/signup/index

window.App =
  Views:
    Signup:
      Theme: {}
  Controllers:
    Themes: {}
  Collections: {}
  Models: {}
  init: ->

$(document).ready ->
  App.init()
