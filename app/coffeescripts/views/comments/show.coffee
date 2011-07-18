App.Views.Comment.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .selector": 'select'

  initialize: ->
    self = this
    this.render()
    @model.bind 'remove', (model) ->
      self.remove()

  render: ->
    attrs = _.clone @model.attributes
    template = Handlebars.compile $('#show-comment-item').html()
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#comments-list > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', this.$('.selector').attr('checked')
