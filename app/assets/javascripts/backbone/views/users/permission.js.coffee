App.Views.User.Permission = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-permissions table-silder hide'
  events:
    "click .action.cancel"  : "hide_permission_tr"
    "click .mark_all"       : "markAll"
    "click .limited_access" : "limitedAccess"
    "submit form"           : "save"


  initialize: ->
    self = this
    this.render()
    if self.$('.mark_all').attr('checked') == 'checked'
      self.markAll()

  render: ->
    attrs = @model.attributes
    attrs['radio_checked'] = attrs['permissions'].length == App.resources_size
    current_user_id = App.current_user['user']['id']
    current_user_is_admin = App.current_user['user']['admin']
    attrs['is_self'] = current_user_id == attrs['id']
    attrs['can_delete']  = !attrs['is_self'] &&  current_user_is_admin
    template = Handlebars.compile $('#show-user-permission').html()
    $(@el).html template attrs
    $('#user-list > table > tbody').append @el
    _.map attrs['permissions'] , (permission) ->
      resource_id = permission.resource_id
      @$(".user_resource_#{resource_id}").attr('checked',true)

  save: ->
    self = this
    ids = _.map @$("input[name='user[permissions][]']:checkbox:checked"), (input) ->
      input.value
    access_flag =$("input[name='user[permissions][]']:radio:checked").val()
    attr = { access_flag: access_flag ,resource_ids: ids , _method: 'put'}
    $.post "/admin/users/#{@model.id}/update_permissions", attr , ->
      msg '更新成功!'
      self.hide_permission_tr()
    false

  hide_permission_tr: ->
    $("#edit-user-permissions-#{@model.id}").hide()
    false

  markAll: ->
    this.$('.permissions-table').hide()

  limitedAccess: ->
    this.$('.permissions-table').show()
