App.Controllers.Theme.Themes.Index = Backbone.Controller.extend

  routes:
    "*splat":      "search"

  initialize: ->

  search: (splat)->
    $(".spinner").show()
    query = _(splat.split('&')).inject (result, item) -> #color=grey&price=free => {color: grey, price: free}
      str = item.split '='
      result[str[0]] = str[1]
      result
    , {}
    _(query).each (value, key) ->
      li = $(".#{key}s ul").children('li')
      li.removeClass('selected')
      $("a[rel='#{value}']", li).parent().addClass('selected')
    $.get "/themes/filter?#{splat}", (data) -> App.themes.refresh data
