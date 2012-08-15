App.Views.Product.Show.Edit = Backbone.View.extend
  el: '#product-edit'

  events:
    "submit form": "save"
    "click .cancel": "show"

  initialize: ->
    _.bindAll this, 'render', 'save'
    @render()

  render: ->
    template = Handlebars.compile $('#edit-product-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs

  save: ->
    self = this
    @model.options.each (model) -> # 循环选项，设置回model
      model.set
        name: model.view.$("input[name='product[options_attributes][][name]']").val()
        value: model.view.$("input[name='product[options_attributes][][value]']").val()
        _destroy: model.view.$("input[name='product[options_attributes][][_destroy]']").val()
    @model._changed = true #修正:只修改option item时也要触发change事件，更新列表
    @model.unset 'photos', silent: true # 有图片会报错"ActiveRecord::AssociationTypeMismatch (Photo)"，图片不是用bb处理，暂时unset
    KE.sync 'kindeditor' # issues#271
    @model.save {
        title: @$("input[name='title']").val(),
        handle: @$("input[name='handle']").val(),
        body_html: @$("textarea[name='body_html']").val(),
        product_type: @$("input[name='product_type']").val(),
        vendor: @$("input[name='vendor']").val(),
        tags_text: @$("input[name='tags_text']").val(),
        custom_collection_ids: _.map @$("input[name='product[custom_collection_ids][]']:checked"), (input) ->
          input.value
      },
      success: (model, resp) ->
        msg '修改成功!'
        self.show()
        new App.Views.ProductOption.Index collection: self.model.options # 显示商品选项
    false

  show: ->
    $('#action-links a.edit-btn').click()
    false
