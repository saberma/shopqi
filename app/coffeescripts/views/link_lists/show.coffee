App.Views.LinkList.Show = Backbone.View.extend
  tagName: 'li'
  className: 'links toolbox link-list'

  events:
    "click .destroy": "destroy"
    "click .editlist-action": "edit"

  initialize: ->
    self = this
    @model.view = this
    @model.bind 'change', (model) -> self.render()
    @render()
    $('#menus').append @el

  render: ->
    self = this
    template = Handlebars.compile $('#link-list-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    new App.Views.LinkList.Links.Index collection: @model.links, el: @$('ul.links')
    new App.Views.LinkList.Links.New link_list: @model, el: @$('.add_form_link_container')
    $(@el).addClass('default-menu') if @model.get('system_default')

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          App.link_lists.remove self.model
          self.remove()
          msg '删除成功!'
    return false

  edit: ->
    new App.Views.LinkList.Edit model: @model, el: @$('.edit_form_link_container')
    false
