# 自定义集合中会用到
Product = Backbone.Model.extend
  name: 'product'

  initialize: (args) ->
    #backbone.rails的initialize被覆盖，导致无法获取id，需要手动调用
    this.maybeUnwrap args
    this.with_options()
    # 保存商品后要重置选项集合
    this.bind 'change:options', this.with_options

  #重载，支持子实体
  toJSON : ->
    attrs = this.wrappedAttributes()
    #手动调用_clone，因为toJSON会加wraper
    if @options?
      options_attrs = @options.models.map (model) ->
        _.clone model.attributes
      attrs['product']['options_attributes'] = options_attrs
    attrs

  #设置关联
  with_options: ->
    if @id? and @attributes.options
      #清除原有选项
      if @options
        _(@options.models).each (model) ->
          model.view.remove()
      #@see http://documentcloud.github.com/backbone/#FAQ-nested
      @options = new App.Collections.ProductOptions
      @options.refresh @attributes.options
      this.unset 'options', silent: true
    this

  addedTo: (collection) ->
    self = this
    collection.detect (model) ->
      model.attributes.product_id == self.id

# 商品选项
ProductOption = Backbone.Model.extend
  name: 'product_option'

# 商品款式
ProductVariant = Backbone.Model.extend
  name: 'product_variant'
