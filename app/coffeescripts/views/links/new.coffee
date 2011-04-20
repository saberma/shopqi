App.Views.Link.New = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.model = new Link
    $("#add_link_control_link_list_#{this.options.link_id}").hide()
    $(this.el).show()

  save: ->
    this.model.save {title: this.$("input[name='link[title]']").val()},
      success: ->
    return false

  cancel: ->
    $(this.el).hide()
    $("#add_link_control_link_list_#{this.options.link_id}").show()
