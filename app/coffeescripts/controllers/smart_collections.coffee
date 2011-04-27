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
    "smart_collections/edit":      "edit"
    "":                            "index"

  edit: (id) ->
    $('.page-edit').show()
    $('#page-show').hide()

  index: ->
    $('.page-edit').hide()
    $('#page-show').show().bind 'click', ->
      window.location = '#pages/edit'
