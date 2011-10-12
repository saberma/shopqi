App.Controllers.Comments = Backbone.Controller.extend

  routes:
    "nothing":      "nothing"
  initialize: ->

    $('#status-filter-link').click ->
      $('#blog-select > ul').hide()
      $('#comment-status-select > ul').toggle()
      false

    $('#blog-filter-link').click ->
      $('#blog-select > ul').toggle()
      $('#comment-status-select > ul').hide()
      false

    $(document).click ->
      $('.dropdown').each ->
        $(this).hide()


