App.Views.LinkList.Links.New = Backbone.View.extend

  events:
    "click .add-action-link a": "add"
    "submit form": "save"
    "click .cancel": "cancel"
    "change .selector": "select" # 选择链接类型

  initialize: ->
    self = this
    @link_list = @options.link_list
    @model = new App.Models.Link link_list_id: @link_list.id
    @link_list.links.unbind 'add' # 修改后新增出现重复记录 issues#243
    @link_list.links.bind 'add', (model, collection) ->
      msg "新增链接#{model.get('title')}到#{self.link_list.get('title')}列表成功."
      self.cancel()
      self.$("input[name='link[title]']").val ''
      self.$("input[name='link[subject]']").val ''
      new App.Views.LinkList.Links.Show model: model
      self.link_list.view.$('.c.note').remove() # 有记录了不显示"无链接"提示
      self.link_list.view.$('.link-header, .links').show()

  save: ->
    self = this
    @link_list.links.create
      title: @$("input[name='title']").val()
      link_type: @$("select[name='link_type']").val()
      subject_handle: @$("select[name='subject_handle']").val()
      subject_params: @$("input[name='subject_params']").val()
      url: self.get_url()
    false

  cancel: ->
    @$('.link').hide()
    @$('.add-action-link').show()
    false

  add: ->
    @$('.link').show()
    @$('.add-action-link').hide()
    @$('.selector').change()
    @$("input[name='url'], input[name='title']").val('')
    false

  select: ->
    toggle_subject_handle = toggle_subject_params = toggle_subject_http = false
    switch @$('.selector').val()
      when 'blog', 'page', 'product'
        @$('select.subject').html($("#selector-#{@$('.selector').val()}-item").html())
        toggle_subject_handle = true
      when 'collection'
        @$('select.subject').html($('#selector-collection-item').html())
        toggle_subject_handle = toggle_subject_params = true
      when 'http'
        toggle_subject_http = true
    @$('select.subject').toggle(toggle_subject_handle)
    @$('input.subject_params').toggle(toggle_subject_params)
    @$('input.subject_http').toggle(toggle_subject_http)

  # private
  get_url: -> # 设置http值
    link_type = @$('.selector').val()
    switch link_type
      when 'blog', 'collection', 'page', 'product' then "/#{link_type}s/#{@$('select.subject').val()}"
      when 'frontpage'  then "/"
      when 'search'     then "/search"
      when 'http'       then @$("input[name='url']").val()
