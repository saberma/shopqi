App.Views.Product.Show.Variant.QuickSelect = Backbone.View.extend
  el: '#variant-options'

  events:
    "click a": 'select'

  initialize: ->
    Handlebars.registerHelper 'each_variant_option', (variant_options, block) ->
      _(variant_options["option#{block.hash.index}"]).map (option_name) ->
        block(name: option_name)
      .join('')
    @render()

  render: ->
    #选项快捷选择
    template = Handlebars.compile $('#variant-options-item').html()
    attrs = _.clone @collection.options()
    attrs['options'] = App.product.options.models
    $(@el).html template attrs

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
