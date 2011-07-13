App.Controllers.Themes.Index = Backbone.Controller.extend

  routes:
    "*splat":      "search"

  initialize: ->

  search: (splat)->
    $.get "/themes/filter?#{splat}", (data) ->
      themes = new App.Collections.Themes data
      new App.Views.Theme.Index.Index collection: themes
