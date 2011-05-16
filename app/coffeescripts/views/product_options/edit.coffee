App.Views.ProductOption.Edit = Backbone.View.extend
  tagName: 'tr'
  className: 'edit-option'

  events:
    "click .del-option": "destroy"
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
    $(@el).html $('#option-item').tmpl attrs
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

  destroy: ->
    App.product_options.remove @model
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
