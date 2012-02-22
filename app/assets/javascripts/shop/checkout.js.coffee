#=require jquery
#=require jquery_ujs

RegionUtils = #地区(冗余代码待重构)
  init: (seed = [], region = '.region') ->
    $(region).each ->
      selects = $('select', this)
      selects.unbind('change') # 避免多次绑定change事件
      selects.change ->
        $this = this
        select_index = selects.index($this) + 1
        select = selects.eq(select_index)
        if $(this).val() and select[0]
          $.get "/district/" + $(this).val(), (data) ->
            result = eval(data)
            options = select[0].options
            $("option:gt(0)", select).remove()
            $.each result, (i, item) -> options.add new Option(item[0], item[1])
            value = seed[select_index]
            select.val(value).change() if value # 级联回显

Validator = # 校验
  validate_blank: (id, field)-> # 是否为空
    obj = $("##{id}")
    if obj.val() is '' # order_email
      $("#error_#{id}").text("#{field}不能为空!").show() # error_order_email
      obj.focus()
      false
    else
      $("#error_#{id}").hide()
      true

  valid_email: (id, field)->
    filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9_]{2,4})+$/
    obj = $("##{id}")
    if !filter.test(obj.val())
      $("#error_#{id}").text("#{field}格式不正确!").show() # error_order_email
      obj.focus()
      false
    else
      $("#error_#{id}").hide()
      true

  validates: (fields)-> # 校验
    flag = true
    $.each fields, (id, field) ->
      flag = Validator.validate_blank(id, field)
      return flag
    flag

$(document).ready ->

  if $('#no-shipping-rates').size() > 0
    $('#complete-purchase').attr 'disabled', true

  $("input[name='order[shipping_rate]']").change -> # 快递费用
    format = $('#cost').attr('format')
    price = parseFloat $(this).attr('start')
    total_price = parseFloat($('#cost').attr('total_price')) + price
    format_price = format.replace /{{amount}}/, total_price
    $('#cost').html(format_price)
    $('#shipping_span').html(" ..包含快递费#{price}元")

  $("#complete-purchase").click -> #处理订单提交结账
    return false unless Validator.validates {
      order_email: 'Email地址',
      order_shipping_address_attributes_name: '姓名',
      order_shipping_address_attributes_province: '省份',
      order_shipping_address_attributes_city: '城市',
      order_shipping_address_attributes_district: '地区',
      order_shipping_address_attributes_address1: '地址',
      order_shipping_address_attributes_phone: '电话'
    }
    return false unless Validator.valid_email('order_email', 'Email地址')
    if $("input[name='order[shipping_rate]']:checked").size() is 0
      alert '请选择配送方式'
      return false
    else if $("input[name='order[payment_id]']:checked").size() is 0
      alert '请选择支付方式'
      return false
    $(this).attr('disabled', 'true').val '正在提交...'
    form = $(this).closest('form')
    $('#purchase-progress').show()
    $.post form.attr('action'), form.serialize(), (data) ->
      $("#complete-purchase").attr('disabled', '').val '提交订单'
      $('#purchase-progress').hide()
      window.location = data.url if data.success is true
    false

  #地区的级联选择
  $(".region").each ->
    selects = $('select', this)
    selects.change ->
      $this = this
      select_index = selects.index($this)
      select = selects.eq(select_index + 1)
      if $(this).val() and select[0]
        $.get "/district/" + $(this).val(), (data) ->
          result = eval(data)
          options = select[0].options
          $("option:gt(0)", select).remove()
          $.each result, (i, item) ->
            options[options.length] = new Option(item[0], item[1])

  #获取地址补全
  $('#billing_address_selector,#shipping_address_selector').each ->
    $(this).change ->
      val = $(this).val()
      action = $(this).closest('form').attr('action').replace(/create_order/i,'get_address')
      if $(this).attr('id') is 'billing_address_selector'
        id = 'billing'
      else
        id = 'shipping'
      $.get action, {address_id: val}, (data) ->
        if data isnt null
          address = data.customer_address
          str = "order_#{id}_address_attributes"
          $("##{str}_name").val(address.name)
          $("##{str}_country_code").val(address.country_code)
          RegionUtils.init [address.province, address.city, address.district], "##{id} .region"
          $("##{str}_province").val(address.province).change()
          $("##{str}_address1").val(address.address1)
          $("##{str}_address2").val(address.address2)
          $("##{str}_zip").val(address.zip)
          $("##{str}_company").val(address.company)
          $("##{str}_phone").val(address.phone)
        else
          reset(str)
    .change()

  reset = (str) ->
      $("##{str}_name").val('')
      $("##{str}_country_code").val('')
      $("##{str}_province").val('')
      $("##{str}_city").val('')
      $("##{str}_district").val('')
      $("##{str}_address1").val('')
      $("##{str}_address2").val('')
      $("##{str}_zip").val('')
      $("##{str}_company").val('')
      $("##{str}_phone").val('')
