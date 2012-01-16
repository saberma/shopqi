#=require jquery
#=require jquery_ujs
#=require backbone_js
#=require plugins
#=require jquery.fancybox-1.3.4.pack
#=require jquery.quicksand
#=require backbone/shopqi
#=require utils/utils
#=require_self

$(document).ready ->
  $(".ie6 #nav-primary li.megadropdown").hover ->
    $(this).children('ul').show()
  , ->
    $(this).children('ul').hide()
