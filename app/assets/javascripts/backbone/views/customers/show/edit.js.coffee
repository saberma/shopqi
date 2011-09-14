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

    Utils.Tag.init()

    default_address = @model.get('default_address')
    Utils.Region.init [default_address.province, default_address.city, default_address.district]
    $('#province').val(default_address.province).change()

  save: ->
    self = this
    attrs =
      customer:
        name: this.$("input[name='customer[name]']").val(),
        accepts_marketing: (this.$("input[name='customer[accepts_marketing]']").attr('checked') is 'checked'),
        note: this.$("textarea[name='customer[note]']").val(),
        tags_text: this.$("input[name='customer[tags_text]']").val(),
        addresses_attributes: [
          id: @model.get('default_address').id,
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
      default_address = self.model.get('default_address')
      _(customer.addresses_attributes[0]).each (value, name) -> default_address[name] = value
      default_address['province_name'] = self.$("select[name='province']").children(':selected').text()
      default_address['city_name'] = self.$("select[name='city']").children(':selected').text()
      default_address['district_name'] = self.$("select[name='district']").children(':selected').text()
      self.model.set customer
      $('#edit-customer-link').click()
      msg '修改成功!'
    false

  cancel: ->
    $('#edit-customer-link').click()
    false
