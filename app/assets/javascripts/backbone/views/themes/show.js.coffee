#=require "backbone/models/shop_theme"
App.Views.Theme.Show = Backbone.View.extend
  tagName: 'li'
  tagClass: 'clearfix'

  events:
    'click .publish-theme-link a'     : 'publish'
    'click .duplicate-theme a'        : 'duplicate'
    'click .delete-theme a'           : 'destroy'
    'click .export-theme a'           : 'export'
    'click .publish-theme-dropdown a' : 'cancel'
    'submit form'                     : 'save'

  initialize: ->
    @render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = _.clone @model.attributes
    attrs['is_main'] = @model.get('role') is 'main'
    attrs['is_published'] = @model.get('role') isnt 'unpublished'
    $(@el).html template attrs
    parent = $(@options.parent)
    parent.show()
    $('ul.theme', parent).append @el

  publish: ->
    @$('.publish-theme-link').hide()
    @$('.publish-theme-dropdown').show()
    false

  duplicate: ->
    self = this
    btn = @$('.duplicate-theme a')
    unless btn.hasClass('disabledrow')
      @$('.duplicate-theme a').addClass('disabledrow')
      $.post "/admin/themes/#{@model.id}/duplicate", (data) ->
        self.$('.duplicate-theme a').removeClass('disabledrow')
        if data['exceed']
          $('#exceed_message').show()
          error_msg '操作不成功!最多只能安装8个主题!'
        else if data['storage_full']
          $('#storage_full_message').show()
          error_msg '操作不成功!商店容量已用完!'
        else
          App.unpublished_themes.add data
    false

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      collection = @model.collection
      @model.destroy
        success: (model, response) ->
          self.remove()
          collection.remove self.model
          msg '删除成功!'
    false

  export: ->
    $.post "/admin/themes/#{@model.id}/export", (data) ->
      msg "正将模板、附件等打包成一个压缩文件，此过程需要几分钟的时间，完成后我们会将文件发送至 #{data}", 5000
    false

  save: ->
    $.post "/admin/themes/#{@model.id}", 'theme[role]': @$("select[name='theme[role]']").val(), _method: 'put', ->
      window.location = window.location # 刷新页面

  cancel: ->
    @$('.publish-theme-link').show()
    @$('.publish-theme-dropdown').hide()
    false
