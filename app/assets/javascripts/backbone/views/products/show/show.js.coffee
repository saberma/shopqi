App.Views.Product.Show.Show = Backbone.View.extend
  el: '#product'

  initialize: ->
    _.bindAll this, 'render'
    @render()
    @model.bind 'change', (model) =>
      this.render()

  render: ->
    attrs = _.clone @model.attributes
    attrs['options'] = @model.options
    attrs['tags'] = StringUtils.to_a attrs.tags_text
    collections = _.map @model.attributes.collection_ids, (id) ->
      collection =
        id: id
        title: $("#collection_#{id}").next('label').text()
    attrs['collections'] = collections
    attrs['collections_empty'] = _.isEmpty collections
    template = Handlebars.compile $('#show-product-item').html()
    $(@el).html template attrs
