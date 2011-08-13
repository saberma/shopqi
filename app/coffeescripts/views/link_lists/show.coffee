App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox default-menu link-list'

  events:
    "click .destroy": "destroy"

  initialize: ->
    _.bindAll this, 'render'
    self = this
    @model.bind 'change', this.render
    @model.bind 'remove', (model) ->
      self.remove()
    $(this.el).attr 'id', "link_lists/#{this.model.id}"
    $('#menus').append this.el
    this.render()

  render: ->
    self = this
    $(this.el).html $('#show-menu').tmpl this.model.attributes
    _.each this.model.links.models, (link) ->
      new App.Views.Link.Show model: link
    #links排序
    this.$(".nobull.sr.ssb").sortable placeholder: "sl link", handle: '.image_handle', update: (event, ui) ->
      $.post "#{self.model.links.url}/sort", $(this).sortable('serialize')
      #排序后设置到model
      ids = _.map $(this).sortable('toArray'), (id) ->
        id.substr(5) #link_1
      i = 0
      _.each ids, (id) ->
        self.model.links.get(id).set { position: i++ }, silent: true
      self.model.links.sort silent: true

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.link_lists.remove self.model
          self.remove()
          #删除成功!
          msg '删除成功!'
    return false
