App.Controllers.SmartCollections = Backbone.Controller.extend

  initialize: ->
    #限制条件选项，字符串类型不能选择"大于"、"等于"，否则meta_search插件会报错
    $('#smartcollectionform').delegate "select[name='smart_collection[rules_attributes][][column]']", 'change', ->
      clazz = $(this).children(':selected').attr('clazz')
      next_select = $(this).next()
      next_select.children().each ->
        if $(this).attr('clazz') in [clazz, 'all']
          $(this).removeClass('hide')
        else
          $(this).addClass('hide')
      if next_select.children(':selected').hasClass('hide')
        next_select.children().first().attr 'selected', 'selected'
    $("#smartcollectionform select[name='smart_collection[rules_attributes][][column]']").change()
    #增加删除条件
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
    #手动排序
    $("#products").sortable handle: '.drag-handle', update: (event, ui) ->
      $.post $(this).attr('url'), $(this).sortable('serialize')
      $('#smart_collection_products_order').val('manual')

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
