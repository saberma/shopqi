App.Views.Customer.Show.Show = Backbone.View.extend
  el: '#customer-summary'

  initialize: ->
    self = this
    @more_addresses = _(@model.get('addresses')).reject (address) -> address.id is self.model.get('address').id
    this.render()
    this.moreOrLess()

  render: ->
    $('#title').text @model.get('name')
    template = Handlebars.compile $('#customer-summary-item').html()
    attrs = _.clone @model.attributes
    attrs['more_addresses'] = @more_addresses
    $(@el).html template attrs

  moreOrLess: ->
    $('#show-customer-addresses').toggle ->
      $('#more-customer-addresses').toggle()
      $(this).html '隐藏地址&hellip;'
    , ->
      $('#more-customer-addresses').toggle()
      $(this).html "另外 #{self.more_addresses.length} 个地址&hellip;"
