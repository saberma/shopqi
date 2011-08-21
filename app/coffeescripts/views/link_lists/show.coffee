App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox default-menu link-list'

  events:
    "click .destroy": "destroy"

  initialize: ->
    self = this
    @model.bind 'change', this.render
    @model.bind 'remove', (model) -> self.remove()
    @render()
    $('#menus').append @el

  render: ->
    self = this
    template = Handlebars.compile $('#link-list-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    new App.Views.LinkList.Links.Index collection: @model.links, el: @$('ul.links')
    new App.Views.LinkList.Links.New link_list: @model, el: @$('.add_link_form_link_list')

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.link_lists.remove self.model
          self.remove()
          msg '删除成功!'
    return false
