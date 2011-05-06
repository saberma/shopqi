App =
  Views:
    LinkList: {}
    Link: {}
    SmartCollection: {}
    CustomCollection: {}
  Controllers: {}
  Collections: {}
  init: ->

#右上角菜单
NavigationDropdown = (navs) ->
  _.each navs, (label, parent_id) ->
    $("<a href='#' onclick='return false;' class='nav-link'>#{label}</a>").prependTo("##{parent_id}").click ->
      $(document).click()
      $(this).addClass('current').next().show()
      false
  $(document).click ->
    $('#secondary > li > a').removeClass 'current'
    $('#secondary > li > .nav-dropdown').hide()



$(document).ready ->
  App.init()

  #外观、设置
  NavigationDropdown 'theme-link': '\u5916\u89C2', 'preferences-link': '\u8BBE\u7F6E'
