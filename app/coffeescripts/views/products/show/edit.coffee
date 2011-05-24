App.Views.Product.Show.Edit = Backbone.View.extend
  el: '#product-edit'

  events:
    "submit form": "save"
    "click .cancel": "show"

  initialize: ->
    _.bindAll this, 'render', 'save'
    this.render()

  render: ->
    $(this.el).html $('#edit-product-item').tmpl this.model.attributes

  save: ->
    self = this
    # 循环选项，设置回model
    @model.options.each (model) ->
      model.set
        name: model.view.$("input[name='product[options_attributes][][name]']").val()
        value: model.view.$("input[name='product[options_attributes][][value]']").val()
        _destroy: model.view.$("input[name='product[options_attributes][][_destroy]']").val()
    #修正:只修改option item时也要触发change事件，更新列表
    @model._changed = true
    @model.save {
        title: this.$("input[name='title']").val(),
        handle: this.$("input[name='handle']").val(),
        body_html: this.$("textarea[name='body_html']").val(),
        product_type: this.$("input[name='product_type']").val(),
        vendor: this.$("input[name='vendor']").val(),
        tags_text: this.$("input[name='tags_text']").val(),
        collection_ids: _.map this.$("input[name='product[collection_ids][]']:checked"), (input) ->
          input.value
      },
      success: (model, resp) ->
        msg '修改成功!'
        self.show()
        #显示商品选项
        new App.Views.ProductOption.Index collection: self.model.options
    false

  show: ->
    $('#action-links a.edit-btn').click()
    false
