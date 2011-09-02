App.Views.Customer.New.Index = Backbone.View.extend
  el: '#main'

  initialize: ->
    this.render()
    TagUtils.init()
    RegionUtils.init()

    # 即时显示
    this.instantText '#customer_name', '#preview_customer_first_name'
    this.instantText '#customer_email', '#preview_customer_email'
    this.instantText '#customer_addresses_attributes__phone', '#preview_customer_phone'
    #this.instantText '#customer_addresses_attributes__company', '#preview_customer_company'
    this.instantSelect '#customer_addresses_attributes__province', '#preview_customer_province'
    this.instantSelect '#customer_addresses_attributes__city', '#preview_customer_city'
    this.instantSelect '#customer_addresses_attributes__district', '#preview_customer_district'
    this.instantText '#customer_addresses_attributes__address1', '#preview_customer_address1'
    this.instantText '#customer_addresses_attributes__zip', '#preview_customer_zip'

  render: ->

  instantText: (src, des) ->
    $(src).keyup ->
      $(des).text $(this).val()
    .keyup()

  instantSelect: (src, des) ->
    $(src).change ->
      option = $(this).children('option:selected')
      $(des).text option.text() if option.val()
    .change()
