App.Views.ApiClient.Show = Backbone.View.extend
  className: 'group'

  events:
    "click .del": 'destroy'

  initialize: ->
    self = this
    this.render()

    @model.bind 'remove', (model) ->
      self.remove()

  render: ->
    attrs = @model.attributes
    template = Handlebars.compile $('#show-api-client-item').html()
    $(@el).html template attrs
    $('#new-api').append @el

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          self.remove()
          msg '删除成功!'
    false
