App.Views.LinkList.Edit = Backbone.View.extend

  events:
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    this.render()

  render: ->
    template = Handlebars.compile $('#edit_form_link_container-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    @model.links.each (link) -> new App.Views.LinkList.Links.Edit model: link, parent: self.$('.edit_links')
    $(@el).show()
    @model.view.$(".default_container_link_list, .add_form_link_container").hide() #隐藏列表窗口、新增链接按钮

  save: ->
    self = this
    $('li', @el).each -> #循环li，把输入项设置回model
      model = self.model.links.get $("input[name='id']", this).val()
      model.set
        title: $("input[name='title']", this).val()
        subject: $("input[name='subject']", this).val()
    this.model._changed = true #修正:只修改link item时也要触发change事件，更新列表
    this.model.save {
        title: this.$("input[name='link_list[title]']").val()
      },
      success: (model, resp) ->
        msg '修改成功!'
        self.cancel()
    return false

  cancel: ->
    $(@el).html ''
    @model.view.$(".default_container_link_list, .add_form_link_container").show() #显示列表窗口、新增链接按钮
    false
