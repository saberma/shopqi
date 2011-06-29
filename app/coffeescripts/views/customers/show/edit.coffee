App.Views.Customer.Show.Edit = Backbone.View.extend
  el: '#edit-customer-screen'

  events:
    "click #update-options": "save"
    "click #cancel-customer-link": "cancel"

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#edit-customer-screen-item').html()
    attrs = _.clone @model.attributes
    attrs['tags'] = App.tags
    $(@el).html template attrs

    TagUtils.init()

    address = @model.get('address')
    RegionUtils.init [address.province, address.city, address.district]
    $('#province').val(address.province).change()

  save: ->
    self = this
    attrs =
      customer:
        name: this.$("input[name='customer[name]']").val(),
        accepts_marketing: this.$("input[name='customer[accepts_marketing]']").attr('checked'),
        note: this.$("textarea[name='customer[note]']").val(),
        tags_text: this.$("input[name='customer[tags_text]']").val(),
        addresses_attributes: [
          id: @model.get('address').id,
          name: this.$("input[name='name']").val(),
          company: this.$("input[name='company']").val(),
          phone: this.$("input[name='phone']").val(),
          province: this.$("select[name='province']").val(),
          city: this.$("select[name='city']").val(),
          district: this.$("select[name='district']").val(),
          address1: this.$("input[name='address1']").val(),
          zip: this.$("input[name='zip']").val(),
        ]
      _method: 'put'
    $.post "/admin/customers/#{@model.id}", attrs, (data) ->
      customer = attrs.customer
      address = self.model.get('address')
      _(customer.addresses_attributes[0]).each (value, name) -> address[name] = value
      address['province_name'] = self.$("select[name='province']").children(':selected').text()
      address['city_name'] = self.$("select[name='city']").children(':selected').text()
      address['district_name'] = self.$("select[name='district']").children(':selected').text()
      self.model.set customer
      $('#edit-customer-link').click()
      msg '修改成功!'
    false

  cancel: ->
    $('#edit-customer-link').click()
    false
