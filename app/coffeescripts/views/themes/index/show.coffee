App.Views.Theme.Index.Show = Backbone.View.extend
  tagName: 'li'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#theme-item').html()
    attrs = @model.attributes
    price = @model.get('price')
    attrs['has_style'] = @model.get('style') not in ['default', 'original']
    attrs['budget'] = if price is 0 then '免费' else "￥#{price}"
    $(@el).attr('data-id', "theme-#{@model.id}").html template attrs
    #$('#themes').append @el
