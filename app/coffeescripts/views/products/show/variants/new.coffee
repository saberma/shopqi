App.Views.Product.Show.Variant.New = Backbone.View.extend
  el: '#new-variant'

  events:
    "click .cancel": "cancel"

  initialize: ->
    _.bindAll this, 'render', 'save'
    this.render()

  render: ->
    $(@el).html $('#new-variant-item').html()

  save: ->
    self = this
    @model.save {
        title: this.$("input[name='title']").val(),
      },
      success: (model, resp) ->
        #修改成功!
        msg '\u4FEE\u6539\u6210\u529F\u0021'
        self.show()
    false

  cancel: ->
    $('#new-variant-link').show()
    $('#new-variant').hide()
    false
