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
        if !$(this).val() # 选中空值时要清空所有下级
          $("option:gt(0)", select).remove()
          select.change()
        else if select[0]
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

  $("#discount_new").submit -> # 提交优惠码
    $("#discount-errors").hide()
    $.post $("#discount_new").attr('action'), code: $("#discount_code").val(), (data) ->
      if data.code
        price = data.amount
        $("#discount_new").hide()
        $("#discount-detail .code").text data.code
        $("#discount-detail .amount").text price
        $("#discount-detail").show()
        $('#cost').attr 'discount_amount', price
        calculate_price()
      else
        $("#discount-errors").show()
        $("#discount-detail").hide()
    false
  $("#discount_new").submit() unless $("#discount_code").val() is '' # 登录后回显优惠码

  $("input[name='order[shipping_rate]']").live 'change', -> # 快递费用
    $('#cost').attr 'shipping_rate', $(this).attr('start')
    calculate_price()

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
    else if $("input[name='order[payment_id]']:checked").size() is 0 and !is_free()
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

  $(".region").each -> #地区的级联选择
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

  $("#order_shipping_address_attributes_district").live 'change ', -> # 选择区下拉框时显示相应的配送方式
    $.getJSON "#{$(this).closest('form').attr('action')}/shipping_rates/#{$(this).val()}", (data)->
      $("#shipping_rates").html('')
      if data
        $.each data, (index, item) ->
          item = item['weight_based_shipping_rate'] || item['price_based_shipping_rate']
          template = $("#shipping-rate-item").html()
          template = template.replace /{{id}}/g, item.id
          template = template.replace /{{price}}/g, item.price
          template = template.replace /{{value}}/g, "#{item.name}-#{item.price}"
          template = template.replace /{{label}}/g, "#{item.name}-#{format(item.price)}"
          $("<li/>").html(template).appendTo($("#shipping_rates"))
      $("#shipping_rates_group").show()
      $("#no-shipping-rates").toggle(!data or data.length is 0)

  $('#shipping_address_selector').change -> #获取地址补全
    if $(this).val()?
      option = $(this).children('option:selected')
      $("#order_shipping_address_attributes_name").val option.attr('name')
      RegionUtils.init [option.attr('province'), option.attr('city'), option.attr('district')], "#shipping .region"
      $("#order_shipping_address_attributes_province").val(option.attr('province')).change()
      $("#order_shipping_address_attributes_address1").val option.attr('address1')
      $("#order_shipping_address_attributes_zip").val option.attr('zip')
      $("#order_shipping_address_attributes_phone").val option.attr('phone')
    else
      reset()
  .change()

  reset = ->
    $("#order_shipping_address_attributes_name").val('')
    $("#order_shipping_address_attributes_province").val('')
    $("#order_shipping_address_attributes_address1").val('')
    $("#order_shipping_address_attributes_zip").val('')
    $("#order_shipping_address_attributes_phone").val('')

  format = (price) -> # 格式化金额
    SHOP_MONEY_IN_EMAILS_FORMAT.replace /{{amount}}/, price

  calculate_price = -> # 计算总金额
    price = pay_price()
    $('#cost').html(format(price))
    $('#discount_span').html(" ..已优惠#{discount_amount()}元").toggle(discount_amount() > 0)
    $('#shipping_span').html(" ..包含快递费#{shipping_rate()}元") unless $('#cost').attr('shipping_rate') is ''
    if price <= 0
      $('#free_payment').show() # 显示免费订单提示
      $('#available_payment').hide()
      $("#available_payment input[name='order[payment_id]']").removeAttr('checked')
    else
      $('#free_payment').hide()
      $('#available_payment').show()

  is_free = -> # 免费订单
    pay_price() <= 0

  pay_price = -> # 待支付的金额
    total_price() - discount_amount() + shipping_rate()

  total_price = -> # 总金额
    parseFloat($('#cost').attr('total_price'))

  discount_amount = -> # 优惠金额
    parseFloat($('#cost').attr('discount_amount') or 0)

  shipping_rate = -> # 运费
    parseFloat($('#cost').attr('shipping_rate') or 0)
