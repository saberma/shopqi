App.Views.LinkList.Links.New = Backbone.View.extend

  events:
    "click .action-link a": "add"
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    self = this
    @link_list = @options.link_list
    @model = new Link link_list_id: @link_list.id
    @link_list.links.bind 'add', (model, collection) ->
      msg "新增链接#{model.get('title')}到#{self.link_list.get('title')}列表成功."
      self.cancel()
      self.$("input[name='link[title]']").val ''
      self.$("input[name='link[subject]']").val ''
      new App.Views.LinkList.Links.Show model: model
      self.link_list.view.$('.default_container_link_list .hint').hide() # 有记录了不显示"无链接"提示
      self.link_list.view.$('.link-header, .links').show()

  save: ->
    self = this
    position = @link_list.links.length
    @link_list.links.create
      position: position
      title: this.$("input[name='link[title]']").val()
      link_type: this.$("input[name='link[link_type]']").val()
      subject: this.$("input[name='link[subject]']").val()
    return false

  cancel: ->
    @$('.link').hide()
    @$('.action-row').show()
    false

  add: ->
    @$('.link').show()
    @$('.action-row').hide()
    false
