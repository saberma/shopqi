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
    @model.links.each (link) -> new App.Views.LinkList.Links.Edit model: link, parent: self.$('.editing-link-list')
    $(@el).show()
    @model.view.$(".default_container_link_list, .add_form_link_container").hide() #隐藏列表窗口、新增链接按钮

  save: ->
    self = this
    $('li', @el).each -> #循环li，把输入项设置回model
      model = self.model.links.get $("input[name='id']", this).val()
      link_type = $('.selector', this).val()
      handle = $("select.subject", this).val()
      url = switch link_type
        when 'blog', 'collection', 'page', 'product' then "/#{link_type}s/#{handle}"
        when 'frontpage'  then "/"
        when 'search'     then "/search"
        when 'http'     then $("input[name='url']", this).val()
      model.set
        title: $("input[name='title']", this).val()
        link_type: link_type
        subject_handle: handle
        subject_params: $("input[name='subject_params']", this).val()
        url: url
    @model._changed = true #修正:只修改link item时也要触发change事件，更新列表
    @model.save {
        title: @$("input[name='link_list[title]']").val(),
        handle: @$("input[name='link_list[handle]']").val(),
      },
      success: (model, resp) ->
        msg '修改成功!'
        self.cancel()
    return false

  cancel: ->
    $(@el).html ''
    @model.view.$(".default_container_link_list, .add_form_link_container").show() #显示列表窗口、新增链接按钮
    false
