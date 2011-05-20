App.Views.Product.Show.Variant.QuickSelect = Backbone.View.extend
  el: '#variant-options'

  events:
    "click a": 'select'

  initialize: ->
    this.render()

  render: ->
    #选项快捷选择
    data = option1: [], option2: [], option3: []
    @collection.each (model) ->
      i = 1
      _(data).each (option, key) ->
        option.push model.attributes["option#{i++}"]
        data[key] = _.uniq _.compact option
    $(@el).html  $('#variant-options-item').tmpl data
    #商品信息中的选项
    $('#product-options-list tr').each (index) ->
      text = data["option#{index+1}"].join(', ')
      $('.option-values-show .small', this).text text

  # 款式选项快捷选择
  select: (ev) ->
    value = $(ev.currentTarget).text()
    view = @collection.view
    if value is '所有'
      view.$('.selector').attr('checked', true)
    else if value is '清空'
      view.$('.selector').attr('checked', false)
    else
      view.$('.selector').attr('checked', false)
      attr = $(ev.currentTarget).parent('span').attr('class').replace /-/, ''
      relate_models = @collection.select (model) ->
        model.attributes[attr] is value
      _(relate_models).each (model) ->
        model.view.$('.selector').attr('checked', true)
    @collection.view.changeProductCheckbox()
    false
