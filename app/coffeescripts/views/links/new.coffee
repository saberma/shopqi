App.Views.Link.New = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.model = new Link link_list_id: this.options.link_list_id
    #隐藏新增按钮
    $("#add_link_control_link_list_#{this.options.link_list_id}").hide()
    $(this.el).show()

  save: ->
    self = this
    link_list = App.link_lists.get this.model.attributes.link_list_id
    link_list.links.create
      title: this.$("input[name='link[title]']").val()
      link_type: this.$("input[name='link[link_type]']").val()
      subject: this.$("input[name='link[subject]']").val()
    return false

  cancel: ->
    $(this.el).hide()
    $("#add_link_control_link_list_#{this.options.link_list_id}").show()
