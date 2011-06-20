App.Views.Order.Show.Cancel = Backbone.View.extend
  el: '#main'

  events:
    'click #cancel-order a': 'show'

  initialize: ->
    this.render()

  show: ->
    template = Handlebars.compile $('#cancel-order-item').html()
    $.blockUI message: template(), css: { width: '630px' }
    $('.blockOverlay,.shopify-dialog-title-close,.close-lightbox').attr('title','单击关闭').click($.unblockUI)
    false
