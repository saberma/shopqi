App.Views.Asset.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "click #open-button": 'open'
    "click #save-button": 'save'
    "click #asset-link-rollback a": 'versions'
    "click #asset-rollback-form a": 'cancelRollback'
    "click #asset-link-destroy a": 'destroy'
    "change #asset-rollback-form select": 'updateAsset'

  initialize: ->
    self = this
    this.render()
    this.templateEditor()

  render: ->
    _(@options.data).each (assets, name) ->
      collection = new App.Collections.Assets assets
      collection.each (asset) -> new App.Views.Asset.Index.Show model: asset, name: name

  open: ->
    window.open("/admin/themes/assets/0/edit", "_blank", "menubar=no,location=no,resizable=yes,scrollbars=yes,status=no,width=900,height=700")

  save: ->
    model = TemplateEditor.current
    value = TemplateEditor.editor.getSession().getValue()
    $('#asset-info').html("正在保存 #{model.get('name')} &hellip;").show()
    $.post '/admin/themes/assets/0', key: model.get('key'), value: value, _method: 'put', ->
      $('#asset-info').html("您的文件已经保存.").fadeOut(5000)
      model.view.setModified false

  versions: ->
    model = TemplateEditor.current
    $.get '/admin/themes/assets/versions', key: model.get('key'), (data) ->
      template = Handlebars.compile $('#rollback-selectbox-item').html()
      $('#asset-links').html template commits: data
    false

  updateAsset: ->
    model = TemplateEditor.current
    tree_id = $('#asset-rollback-form select').children('option:selected').attr('tree_id')
    $.get "/admin/themes/asset/#{tree_id}", key: model.get('key'), (data) ->
      editor = TemplateEditor.editor
      editor.getSession().setValue data
      editor.moveCursorTo(0,0)
    false

  destroy: ->
    self = this
    model = TemplateEditor.current
    attrs = key: model.get('key'), _method: 'delete'
    $.post "/admin/themes/assets/0", attrs, (data) ->
      msg "#{model.get('key')}已经删除"
      model.view.remove()
    false

  cancelRollback: ->
    $('#asset-links').html $('#asset-link-rollback-item').html()
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
      RequiredFiles: ["layout/theme.liquid","templates/index.liquid","templates/collection.liquid","templates/product.liquid","templates/page.liquid","templates/cart.liquid","templates/blog.liquid"]
      text_extensions: ['wmls','csv','vsc','qxb','qxt','kml','rb','ltx','ps','sl','cc','qxd','fsc','shar','txt','coffee','cmd','php','liquid','xpm','t','js','imagemap','csh','roff','html','htmlx','texinfo','cpp','htm','bat','vcs','atc','smi','c','phtml','py','pht','xslt','rtx','ai','tex','hqx','ccc','dat','xmt_txt','svg','xlsx','dtd','troff','eps','hpp','xps','qwt','shtml','atom','h','xhtml','xsl','qxl','man','vcf','x_t','hlp','pl','rhtml','qwd','xbm','wml','eol','sgm','json','rst','htc','etx','hh','xml','m4u','yaml','eml','kmz','tcl','yml','texi','asc','acutc','rbw','smil','rdf','imap','sh','mxu','tr','htx','css','si','jad','latex','tsv']
      image_extensions: [ 'jpg', 'gif', 'png', 'jpeg' ]
