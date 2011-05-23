App.Controllers.Users = Backbone.Controller.extend

  initialize: ->
    $('#add-user').click ->
      $("#new-user-form").toggle()
      $("#add-user").toggle()
      false

    $('#cancel').click ->
      $('#new-user-form').hide()
      $('#add-user').show()
      false



