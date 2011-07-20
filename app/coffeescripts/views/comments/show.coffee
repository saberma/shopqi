App.Views.Comment.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .selector": 'select'
    "click .destroy" : 'destroy'
    "click .not_spam"    : 'not_spam'
    "click .spam"    : 'spam'

  initialize: ->
    self = this
    this.render()
    @model.bind 'remove', (model) ->
      self.remove()

  render: ->
    attrs = _.clone @model.attributes
    switch attrs['status']
      when 'spam' then attrs['is_spam'] = true
      when 'published' then attrs['is_published'] = true
      when 'unapproved' then attrs['is_unapproved'] = true
    template = Handlebars.compile $('#show-comment-item').html()
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row#{cycle}"
    $('#comments-list > tbody').append @el

  select: ->
    $(@el).toggleClass 'active', this.$('.selector').attr('checked')

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          self.remove()
          msg '删除成功!'
    false

  not_spam: ->
    self = this
    this.model.save {status: 'published'},
      success: (model,resp) ->
        self.render()

  spam: ->
    self = this
    this.model.save {status: 'spam'},
      success: (model,resp) ->
        self.render()

