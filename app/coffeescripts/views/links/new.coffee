App.Views.Link.New = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    $("#add_link_control_link_list_#{this.options.link_id}").hide()
    $(this.el).show()

  save: ->
    return false

  cancel: ->
    $(this.el).hide()
    $("#add_link_control_link_list_#{this.options.link_id}").show()
