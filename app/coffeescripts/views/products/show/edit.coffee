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
    @model.save {
        title: this.$("input[name='title']").val(),
        handle: this.$("input[name='handle']").val(),
        body_html: this.$("textarea[name='body_html']").val(),
        product_type: this.$("input[name='product_type']").val(),
        vendor: this.$("input[name='vendor']").val()
      },
      success: (model, resp) ->
        #修改成功!
        msg '\u4FEE\u6539\u6210\u529F\u0021'
        self.show()
    false

  show: ->
    $('#action-links a.edit-btn').click()
    false
