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
    this.render()

  render: ->
    self = this
    position = _.indexOf @model.collection.models, @model
    cycle = if position % 2 == 0 then 'even' else 'odd'
    $(@el).addClass cycle
    attrs = _.clone @model.attributes
    attrs['destroyable'] = position isnt 0
    $(@el).html $('#edit-option-item').tmpl attrs
    #选择第一个未被选择的option
    values = $('.option-selector').map -> this.value
    this.$('.option-selector').children('option').each ->
      if this.value not in values
        self.$('.option-selector').val(this.value)
        false
    $('#add-option-bt').before @el
    UpdateableSelectBox this.$('.option-selector'), '\u81EA\u5B9A\u4E49' #自定义
    #默认值(有值时不设置默认值)
    this.setDefaultValue() unless @model.attributes.value
    this.disableOption()

  resumeOption: ->
    @model._destroy = false
    this.$('.option-deletemsg').hide()
    this.$('.option-selector-frame').show()
    this.$('.delete-option-link').show()
    this.$('.option-value').show()
    #已保存过的删除时要带上_destroy属性
    this.$("input[name='product[options_attributes][][_destroy]']").val('0')
    false

  destroy: ->
    undestroy_product_options = _(@model.collection.models).reject (model) -> typeof(model._destroy) isnt "undefined" and model._destroy
    if undestroy_product_options.length == 1
      #alert '最后一个商品选项不能删除. 商品至少需要一个选项.'
      alert '\u6700\u540E\u4E00\u4E2A\u5546\u54C1\u9009\u9879\u4E0D\u80FD\u5220\u9664\u002E\u0020\u5546\u54C1\u81F3\u5C11\u9700\u8981\u4E00\u4E2A\u9009\u9879.'
      return false
    if @model.id
      @model._destroy = true
      this.$('.option-deletemsg').show()
      this.$('.option-selector-frame').hide()
      this.$('.delete-option-link').hide()
      this.$('.option-value').hide()
      #已保存过的删除时要带上_destroy属性
      this.$("input[name='product[options_attributes][][_destroy]']").val('1')
      return false
    @model.collection.remove @model
    this.disableOption()
    return false

  # 每个选项名称只能被选择一次
  disableOption: ->
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

  # 设置默认值
  setDefaultValue: ->
    #this.$("name['product[options_attributes][][value]']").val("默认#{this.$('.option-selector > option:selected').text()}")
    value = "\u9ED8\u8BA4"
    value += this.$('.option-selector > option:selected').text() if this.$('.option-selector').val() isnt 'create_new'
    this.$("input[name='product[options_attributes][][value]']").val(value)
