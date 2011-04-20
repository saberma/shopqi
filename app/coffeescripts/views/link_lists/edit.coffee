App.Views.LinkList.Edit = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.render()

  save: ->
    self = this
    this.model.save {title: this.$("input[name='link_list[title]']").val()}
      success: (model, resp) ->
        $(self.el).hide()
        $("#default_container_link_list_#{model.id}").show()
        Backbone.history.saveLocation "link_lists/#{model.id}"
      error: ->
        new App.Views.Error
    return false

  render: ->
    $(this.el).html $('#edit-menu').tmpl this.model.attributes
    $(this.el).show()
    this.$("input[name='link_list[title]']").focus()
    $("#default_container_link_list_#{this.model.id}").hide()

  cancel: ->
    $(this.el).hide()
