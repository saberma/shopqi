App.Views.LinkList.Links.Edit = Backbone.View.extend
  tagName: 'li'
  className: 'sl link link-edit'

  events:
    "click .delete": "destroy"

  initialize: ->
    @render()
    @options.parent.append @el

  render: ->
    template = Handlebars.compile $('#edit-link-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    index = _.indexOf @model.collection.models, @model
    cycle = if index % 2 == 0 then 'odd' else 'even'
    $(@el).addClass cycle

  destroy: ->
    if confirm '您确定要删除吗?'
      self = this
      collection = @model.collection
      this.model.destroy
        success: (model, response) ->
          collection.remove self.model
          self.remove()
          msg '删除成功!'
    return false
