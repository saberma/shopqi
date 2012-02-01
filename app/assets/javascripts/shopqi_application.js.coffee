#=require jquery
#=require jquery_ujs
#=require backbone_js
#=require plugins
#=require jquery.fancybox-1.3.4
#=require jquery.quicksand
#=require backbone/shopqi
#=require utils/utils
#=require_self

$(document).ready ->
  $(".ie6 #nav-primary li.megadropdown").hover -> # 官网页头导航
    $(this).children('ul').show()
  , ->
    $(this).children('ul').hide()

  $('.ie6 ').delegate '#themes li a, ul.theme-thumbs a', 'mouseover mouseout', (event) ->  # 鼠标悬停时显示主题商店主题价格
    if event.type is 'mouseover'
      $('p', this).show()
    else if event.type is 'mouseout'
      $('p', this).hide()
