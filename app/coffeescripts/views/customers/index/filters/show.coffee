App.Views.Customer.Index.Filter.Show = Backbone.View.extend
  className: 'filter-tag'

  events:
    "click .close-filter-tag": 'destroy' # 删除主过滤器

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()

  # 删除过滤器
  destroy: ->
    @model.collection.remove @model
    this.remove()
    false

  render: ->
    template = Handlebars.compile $('#customer-search_filters-item').html()
    $(@el).html template @model.attributes
    $('#customer-search_filters').append @el
