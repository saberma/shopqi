App.Controllers.SmartCollections = Backbone.Controller.extend

  initialize: ->
    $('#smartcollectionform').delegate '.add_rule', 'click', ->
      li = $('#smartcollectionform > li').first().clone()
      #去掉id属性
      $("input[name='smart_collection[rules_attributes][][id]']", li).remove()
      li.appendTo('#smartcollectionform')
      false
    $('#smartcollectionform').delegate '.del_rule', 'click', ->
      if $('#smartcollectionform > li:visible').size() == 1 then return false
      li = $(this).closest('li.condition-line')
      id = $("input[name='smart_collection[rules_attributes][][id]']", li).val()
      #http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html
      #已保存过的删除时要带上_destroy属性
      if id
        $("input[name='smart_collection[rules_attributes][][_destroy]']", li).val('1')
        li.hide()
      else
        li.remove()
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
