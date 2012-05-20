App.Views.ProductOption.Edit = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-option'

  events:
    "click .del-option": "destroy"
    "click .resume-option": "resumeOption"
    "change .option-selector": "disableOption"
    "change .option-selector": "setDefaultValue"

  initialize: ->
    _.bindAll this, 'destroy', 'disableOption', 'setDefaultValue'
    @model.view = this
    @render()

  render: ->
    self = this
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'even' else 'odd'
    $(@el).addClass cycle
    attrs = _.clone @model.attributes
    attrs['destroyable'] = position isnt 0
    template = Handlebars.compile $('#edit-option-item').html()
    $(@el).html template attrs
    #选择第一个未被选择的option
    values = $('.option-selector').map -> this.value
    @$('.option-selector').children('option').each ->
      if this.value not in values
        self.$('.option-selector').val(this.value)
        false
    $('#add-option-bt').before @el
    UpdateableSelectBox @$('.option-selector'), '自定义'
    #默认值(有值时不设置默认值)
    @setDefaultValue() unless @model.attributes.value
    @disableOption()

  resumeOption: ->
    @model._destroy = false
    @$('.option-deletemsg').hide()
    @$('.option-selector-frame').show()
    @$('.delete-option-link').show()
    @$('.option-value').show()
    #已保存过的删除时要带上_destroy属性
    @$("input[name='product[options_attributes][][_destroy]']").val('0')
    false

  destroy: ->
    undestroy_product_options = _(@model.collection.models).reject (model) -> typeof(model._destroy) isnt "undefined" and model._destroy
    if undestroy_product_options.length == 1
      alert '最后一个商品选项不能删除. 商品至少需要一个选项.'
      return false
    if @model.id
      @model._destroy = true
      @$('.option-deletemsg').show()
      @$('.option-selector-frame').hide()
      @$('.delete-option-link').hide()
      @$('.option-value').hide()
      #已保存过的删除时要带上_destroy属性
      @$("input[name='product[options_attributes][][_destroy]']").val('1')
      return false
    @model.collection.remove @model
    @disableOption()
    return false

  disableOption: -> # 每个选项名称只能被选择一次
    values = $('.option-selector').map -> this.value
    $('.option-selector').each ->
      value = $(this).val()
      $(this).children('option').each ->
        val = $(this).val()
        if val and val isnt 'create_new'
          if val in values and val isnt value
            $(this).attr('disabled', true)
          else
            $(this).attr('disabled', false)
    return false

  setDefaultValue: -> # 设置默认值
    #this.$("name['product[options_attributes][][value]']").val("默认#{this.$('.option-selector > option:selected').text()}")
    value = "\u9ED8\u8BA4"
    value += @$('.option-selector > option:selected').text() if @$('.option-selector').val() isnt 'create_new'
    @$("input[name='product[options_attributes][][value]']").val(value)
