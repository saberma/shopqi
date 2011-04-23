App.Views.LinkList.Edit = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.render()

  save: ->
    self = this
    #循环li，把输入项设置回model
    $('li', this.el).each ->
      model = self.model.links.get $("input[name='id']", this).val()
      model.set
        title: $("input[name='title']", this).val()
        subject: $("input[name='subject']", this).val()
    #修正:只修改link item时也要触发change事件，更新列表
    this.model._changed = true
    this.model.save {
        title: this.$("input[name='link_list[title]']").val()
      },
      success: (model, resp) ->
        #修改成功!
        msg '\u4FEE\u6539\u6210\u529F\u0021'
        $(self.el).hide()
        #显示列表窗口、新增链接按钮
        $("#default_container_link_list_#{model.id}").show()
        $("#add_form_link_container_link_list_#{model.id}").show()
        Backbone.history.saveLocation "link_lists/#{model.id}"
      #error: (model, response) ->
      #  new App.Views.Error
    return false

  render: ->
    $(this.el).html $('#edit-menu').tmpl this.model.attributes
    _.each this.model.links.models, (link) ->
      new App.Views.Link.Edit model: link
    $(this.el).show()
    this.$("input[name='link_list[title]']").focus()
    #隐藏列表窗口、新增链接按钮
    $("#default_container_link_list_#{this.model.id}").hide()
    $("#add_form_link_container_link_list_#{this.model.id}").hide()

  cancel: ->
    $(this.el).hide()
    #显示列表窗口、新增链接按钮
    $("#default_container_link_list_#{this.model.id}").show()
    $("#add_form_link_container_link_list_#{this.model.id}").show()
