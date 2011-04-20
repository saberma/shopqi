App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox default-menu link-list'

  initialize: ->
    _.bindAll this, 'render'
    this.model.bind 'change', this.render
    $(this.el).attr 'id', "link_lists/#{this.model.id}"
    this.render()
    $('#menus').append this.el

  events:
    "click .destroy": "destroy"

  render: ->
    $(this.el).html $('#show-menu').tmpl this.model.attributes

  destroy: ->
    #therubyracer暂时无法编译中文，最新版已修正问题但未发布
    #if confirm '您确定要删除吗'
    if confirm '\u60A8\u786E\u5B9A\u8981\u5220\u9664\u5417'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.link_lists.remove self.model
          self.remove()
          #删除成功!
          msg '\u5220\u9664\u6210\u529F\u0021'
    return false
