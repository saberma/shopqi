App.Controllers.Themes.Index = Backbone.Controller.extend

  routes:
    "*splat":      "search"

  initialize: ->

  search: (splat)->
    $.get "/themes/filter?#{splat}", (data) -> App.themes.refresh data
