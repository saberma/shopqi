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
    this.model.save {
        title: this.$("input[name='link[title]']").val()
        link_type: this.$("input[name='link[link_type]']").val()
        subject: this.$("input[name='link[subject]']").val()
      },
      success: (model, response) ->
        #显示新增按钮、隐藏自己
        $("#add_link_control_link_list_#{model.attributes.link_list_id}").show()
        $(self.el).hide()
        self.$("input[name='link[title]']").val ''
        self.$("input[name='link[subject]']").val ''
        new App.Views.Link.Show model: model
        Backbone.history.saveLocation "link/#{model.id}"

    return false

  cancel: ->
    $(this.el).hide()
    $("#add_link_control_link_list_#{this.options.link_list_id}").show()
