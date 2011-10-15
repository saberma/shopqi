#=require jquery
#=require jquery_ujs
#=require backbone_js
#=require plugins
#=require jquery.fancybox-1.3.4.pack
#=require jquery.quicksand
#=require_self
#=require backbone/signup
#=require backbone/theme
#=require utils/utils

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
