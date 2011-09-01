class Theme extends Backbone.Model
  name: 'theme'

  clone_attributes: ->
    attrs = _.clone this.attributes
    price = this.get('price')
    attrs['has_style'] = this.get('style') not in ['default', 'original']
    attrs['budget'] = if price is 0 then '免费' else "￥#{price}"
    attrs



App.Collections.Themes = Backbone.Collection.extend
  model: Theme
