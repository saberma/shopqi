App.Controllers.Users = Backbone.Controller.extend
  
  routes:
    "users/:id": "show"
    "user/new": "new"
    "": "index"


  show: (id) ->


  new: ->
    $("#new-user-form").toggle()
    $("#add-user").toggle()

  index: ->
    $("#new-user-form").hide()
    $("#add-user").show()



    


