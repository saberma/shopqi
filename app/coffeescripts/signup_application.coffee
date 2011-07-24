App =
  Views:
    Signup:
      Theme: {}
  Controllers:
    Themes: {}
  Collections: {}
  init: ->

#特效
Effect =
  scrollTo: (id) ->
    destination = $(id).offset().top
    $("html:not(:animated),body:not(:animated)").animate {
      scrollTop: destination-20
    }, 1000

$(document).ready ->
  App.init()
