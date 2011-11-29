App.Views.User.Permission = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-permissions table-silder hide'
  events:
    "click .action.cancel" : 'hide_permission_tr'
    "click #mark_all" : "markAll"
    "click #limited_access" : "limitedAccess"


  initialize: ->
    self = this
    this.render()
    if self.$('#mark_all').attr('checked') == 'checked'
      self.markAll()

  render: ->
    attrs = @model.attributes
    current_user_id = App.current_user['user']['id']
    current_user_is_admin = App.current_user['user']['admin']
    attrs['is_self'] = current_user_id == attrs['id']
    attrs['can_delete']  = !attrs['is_self'] &&  current_user_is_admin
    template = Handlebars.compile $('#show-user-permission').html()
    $(@el).html template attrs
    $('#user-list > table > tbody').append @el

  hide_permission_tr: ->
    $("#edit-user-permissions-#{@model.id}").hide()
    false

  markAll: ->
    this.$('.permissions-table').hide()

  limitedAccess: ->
    this.$('.permissions-table').show()
