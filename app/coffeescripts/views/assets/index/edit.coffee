App.Views.Asset.Index.Edit = Backbone.View.extend
  el: '#asset-details'

  events:
    "click #save-button": 'save'

  initialize: ->
    $('#template-editor').css('display','block').width('100%').height('93%').css('position','absolute').css('top','7%').css('left', '0')
    self = this
    @parent_editor = opener.window.TemplateEditor
    @model = @parent_editor.current.clone()
    this.render()

  render: ->
    self = this
    $('#asset-title').text @model.get('name')
    @editor = ace.edit("template-editor")
    @editor.setTheme 'ace/theme/clouds'
    @session = @editor.getSession()
    extension = @model.extension()
    mode = if extension in ['css', 'js'] then "#{extension}_mode" else 'html_mode'
    @session.setMode new @parent_editor[mode]
    @session.setValue @parent_editor.editor.getSession().getValue()
    @session.setUseSoftTabs true
    @editor.moveCursorTo(0,0)
    @editor.resize()
    window.onresize = -> self.editor.resize()
    false

  save: ->
    @parent_editor.editor.getSession().setValue @session.getValue()
    opener.window.$('#save-button').click()
