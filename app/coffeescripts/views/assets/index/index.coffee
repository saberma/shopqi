App.Views.Asset.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #new_layout_reveal_link a": 'addLayout'
    "click #new-layout a": 'cancelLayout'
    "click #new_layout_btn": 'saveLayout'
    "click #new_template_reveal_link a": 'addTemplate'
    "click #new-template a": 'cancelTemplate'
    "click #new_template_btn": 'saveTemplate'

  initialize: ->
    self = this
    this.templateEditor()
    this.render()

  render: ->
    self = this
    @assets = {}
    _(@options.data).each (assets, name) ->
      collection = new App.Collections.Assets assets
      self.assets[name] = collection
      collection.each (asset) -> new App.Views.Asset.Index.Show model: asset, name: name
      collection.bind 'add', (asset) -> new App.Views.Asset.Index.Show(model: asset, name: name).show()
    new App.Views.Asset.Index.Panel()

  saveLayout: ->
    self = this
    source = $('#new-layout-selectbox').children('option:selected')
    [source_key, source_name] = [source.val(), source.text()]
    name = $('#new_layout_basename_without_ext').val()
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    key = source_key.replace source_name, name
    attrs = key: key, source_key: source_key
    $.post '/admin/themes/assets', attrs, (data) ->
      self.assets.layout.add key: key, name: name
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
    [key, name] = ["templates/#{source.val()}.liquid", "#{source.text()}.liquid"]
    name = "#{name}.liquid" unless StringUtils.endsWith(name, '.liquid')
    $.post '/admin/themes/assets', key: key, (data) ->
      self.assets.templates.add key: key, name: name
      self.cancelTemplate()

  addTemplate: ->
    self = this
    $('#new-template-selectbox').children('option').each ->
      value = $(this).val()
      created = self.assets.templates.detect (model) -> model.get('name') is value
      $(this).toggle !created
    $('#new_template_reveal_link').hide()
    $('#new-template').show()
    false

  cancelTemplate: ->
    $('#new_template_reveal_link').show()
    $('#new-template').hide()
    false

  templateEditor: ->
    window.TemplateEditor =
      editor: null
      current: null # 当前编辑的主题文件实体对象
      html_mode: require("ace/mode/html").Mode
      css_mode: require("ace/mode/css").Mode
      js_mode: require("ace/mode/javascript").Mode
      UndoManager: require("ace/undomanager").UndoManager
      EditSession: require("ace/edit_session").EditSession
      RequiredFiles: ["layout/theme.liquid","templates/404.liquid","templates/article.liquid","templates/index.liquid","templates/collection.liquid","templates/product.liquid","templates/page.liquid","templates/cart.liquid","templates/blog.liquid","templates/search.liquid"]
      text_extensions: ['wmls','csv','vsc','qxb','qxt','kml','rb','ltx','ps','sl','cc','qxd','fsc','shar','txt','coffee','cmd','php','liquid','xpm','t','js','imagemap','csh','roff','html','htmlx','texinfo','cpp','htm','bat','vcs','atc','smi','c','phtml','py','pht','xslt','rtx','ai','tex','hqx','ccc','dat','xmt_txt','svg','xlsx','dtd','troff','eps','hpp','xps','qwt','shtml','atom','h','xhtml','xsl','qxl','man','vcf','x_t','hlp','pl','rhtml','qwd','xbm','wml','eol','sgm','json','rst','htc','etx','hh','xml','m4u','yaml','eml','kmz','tcl','yml','texi','asc','acutc','rbw','smil','rdf','imap','sh','mxu','tr','htx','css','si','jad','latex','tsv']
      image_extensions: [ 'jpg', 'gif', 'png', 'jpeg' ]
