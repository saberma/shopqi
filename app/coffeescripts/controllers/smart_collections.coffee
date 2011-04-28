App.Controllers.SmartCollections = Backbone.Controller.extend

  initialize: ->
    $('#smartcollectionform').delegate '.add_rule', 'click', ->
      li = $('#smartcollectionform > li').first().clone()
      $("[name='smart_collection[rules_attributes][][id]']", li).remove()
      li.appendTo('#smartcollectionform')
      false
    $('#smartcollectionform').delegate '.del_rule', 'click', ->
      if $('#smartcollectionform > li').size() == 1 then return false
      $(this).closest('li.condition-line').remove()
      false

  routes:
    "edit":      "edit"
    "":          "index"

  edit: (id) ->
    $('#collection-edit').show()
    $('#collection-description').hide()

  index: ->
    $('#collection-edit').hide()
    $('#collection-description').show().bind 'click', ->
      window.location = '#edit'
