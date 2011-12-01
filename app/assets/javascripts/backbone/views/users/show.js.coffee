App.Views.User.Show = Backbone.View.extend
  tagName: 'tr'

  events:
    "click .destroy" : 'destroy'
    "click .set_permissions" : 'toggle_permission_tr'

  initialize: ->
    self = this
    this.render()
    @model.bind 'remove', (model) ->
      self.remove()

  render: ->
    attrs = @model.attributes
    current_user_id = App.current_user['user']['id']
    current_user_is_admin = App.current_user['user']['admin']
    attrs['is_self'] = current_user_id == attrs['id']
    attrs['can_delete']  = !attrs['is_self'] &&  current_user_is_admin
    template = Handlebars.compile $('#show-user-list').html()
    $(@el).html template attrs
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'odd' else 'even'
    $(@el).addClass "row #{cycle}"
    $('#user-list > table > tbody').append @el

  destroy: ->
    if confirm '您确定要删除吗'
      self = this
      this.model.destroy
        success: (model, response) ->
          self.remove()
          msg '删除成功!'
    false

  toggle_permission_tr: ->
    $("#edit-user-permissions-#{@model.id}").toggle()
    false
