App.Views.LinkList.Links.Show = Backbone.View.extend
  tagName: 'li'
  className: 'sl link'

  initialize: ->
    self = this
    @model.view = this
    $(@el).attr 'id', "link_#{@model.id}" # 排序时需要id
    this.render()

  render: ->
    self = this
    template = Handlebars.compile $('#link-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs
    $(@model.collection.view.el).append @el
