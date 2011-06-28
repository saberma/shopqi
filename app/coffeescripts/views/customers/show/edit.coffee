App.Views.Customer.Show.Edit = Backbone.View.extend
  el: '#edit-customer-screen'

  initialize: ->
    self = this
    this.render()

  render: ->
    template = Handlebars.compile $('#edit-customer-screen-item').html()
    attrs = _.clone @model.attributes
    $(@el).html template attrs

    address = @model.get('address')
    region = [address.province, address.city, address.district]
    $(".region").each ->
      selects = $('select', this)
      selects.change ->
        $this = this
        select_index = selects.index($this) + 1
        select = selects.eq(select_index)
        if $(this).val() and select[0]
          $.get "/district/" + $(this).val(), (data) ->
            result = eval(data)
            options = select.attr("options")
            $("option:gt(0)", select).remove()
            $.each result, (i, item) -> options[options.length] = new Option(item[0], item[1])
            value = region[select_index]
            select.val(value).change() if value # 级联回显

    $('#province').val(address.province).change()
