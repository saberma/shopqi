App.Views.Link.Show = Backbone.View.extend
  tagName: 'li'
  className: 'sl link'

  initialize: ->
    self = this
    #显示列表、隐藏无ITEM的提示
    link_list_container_id = "#default_container_link_list_#{this.model.attributes.link_list_id}"
    $('.padding', link_list_container_id).hide()
    $('.sr', link_list_container_id).show()
    _.bindAll this, 'render'
    $(this.el).attr 'id', "link_#{this.model.id}"
    this.render()
    @model.bind 'remove', (model) ->
      self.remove()
    $('.nobull', link_list_container_id).append this.el

  render: ->
    $(this.el).html $('#show-link-menu').tmpl this.model.attributes
    position = _.indexOf this.model.collection.models, this.model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(this.el).addClass cycle
