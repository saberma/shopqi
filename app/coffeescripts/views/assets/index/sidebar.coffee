# 新增处理
App.Views.Asset.Index.Sidebar = Backbone.View.extend
  el: '#theme-editor-sidebar-top'

  events:
    "click #new_layout_reveal_link a": 'addLayout'
    "click #new-layout a": 'cancelLayout'
    "click #new_layout_btn": 'saveLayout'
    "click #new_template_reveal_link a": 'addTemplate'
    "click #new-template a": 'cancelTemplate'
    "click #new_template_btn": 'saveTemplate'
    "click #new_snippet_reveal_link a": 'addSnippet'
    "click #new-snippet a": 'cancelSnippet'
    "click #new_snippet_btn": 'saveSnippet'

  initialize: ->
    self = this
    this.render()

  render: ->

  saveLayout: ->
    self = this
    source = $('#new-layout-selectbox').children('option:selected')
    [source_key, source_name] = [source.val(), source.text()]
    name = $('#new_layout_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = source_key.replace source_name, name
    attrs = key: key, source_key: source_key
    $.post '/admin/themes/assets', attrs, (data) ->
      self.options.assets.layout.add key: key, name: name
      self.cancelLayout()

  addLayout: ->
    $('#new_layout_reveal_link').hide()
    template = Handlebars.compile $('#new-layout-selectbox-item').html()
    $('#new-layout-selectbox').html template layouts: @options.data.layout
    $('#new-layout').show()
    $('#new_layout_basename_without_ext').focus()
    false

  cancelLayout: ->
    $('#new_layout_reveal_link').show()
    $('#new-layout').hide()
    $('#new_layout_basename_without_ext').val ''
    false

  saveTemplate: ->
    self = this
    source = $('#new-template-selectbox').children('option:selected')
    unless source[0]
      error_msg '没有候选模板!'
      return
    [key, name] = ["templates/#{source.val()}.liquid", "#{source.text()}.liquid"]
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    $.post '/admin/themes/assets', key: key, (data) ->
      self.options.assets.templates.add key: key, name: name
      self.cancelTemplate()

  addTemplate: ->
    self = this
    $('#new-template-selectbox').children('option').each ->
      value = "#{$(this).val()}.liquid"
      created = self.options.assets.templates.detect (model) -> model.get('name') is value
      $(this).toggle(!created).attr('disabled', created)
    $('#new-template-selectbox').val $('#new-template-selectbox').children('option:enabled:first').val()
    $('#new_template_reveal_link').hide()
    $('#new-template').show()
    false

  cancelTemplate: ->
    $('#new_template_reveal_link').show()
    $('#new-template').hide()
    false

  saveSnippet: ->
    self = this
    name = $('#new_snippet_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = "snippets/#{name}"
    $.post '/admin/themes/assets', key: key, (data) ->
      self.options.assets.snippets.add key: key, name: name
      self.cancelSnippet()

  addSnippet: ->
    self = this
    $('#new_snippet_reveal_link').hide()
    $('#new-snippet').show()
    $('#new_snippet_basename_without_ext').focus()
    false

  cancelSnippet: ->
    $('#new_snippet_reveal_link').show()
    $('#new-snippet').hide()
    $('#new_snippet_basename_without_ext').val ''
    false
