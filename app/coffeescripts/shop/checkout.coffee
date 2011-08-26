$(document).ready ->

  #处理地址，级联操作税率
  $('#order_billing_address_attributes_country_code,#order_shipping_address_attributes_country_code').each ->
    $(this).change ->
      checked = $('#shipping-toggle').attr('checked')
      country_code = $(this).val()
      if country_code isnt 'CN'
        $(this).closest('table').find('.region').parent().hide()
      else
        $(this).closest('table').find('.region').parent().show()
      if $(this).attr('id') == 'order_billing_address_attributes_country_code' and !checked
        return false
      action = $(this).closest('form').attr('action').replace(/create_order/i,'update_tax_price')
      $.post action, { country_code: country_code, shipping_same: checked }, (data) ->
        img = $("#cost :first-child")[0]
        $('#cost').html('¥' + data.total_price).append(img)
        $('#tax_span').html(" ..包含#{data.order_tax_price}元的税")
      $(this).ajaxStart ->
        $('.spinner').show()
      $(this).ajaxStop ->
        $('.spinner').hide()

  #/carts/xxx 页面处理货品地址和发单地址
  $('#shipping-toggle').change ->
    checked = $(this).attr('checked')
    $('#shipping').toggle !checked
    $('#shipping-same').toggle checked
    if checked
      $('#order_billing_address_attributes_country_code').change()
    else
      $('#order_shipping_address_attributes_country_code').change()
  .change()

  if $('#no-shipping-rates').size() > 0
    $('input#complete-purchase').attr 'disabled', true

  #处理快递费用
  $('#shipping-rates').change ->
    action = $(this).closest('form').attr('action')
    href = action.substr(0,action.lastIndexOf('/')) + '/update_total_price'
    rate = $(this).val()
    $.post href, { shipping_rate: rate }, (data) ->
      if data.error is 'shipping_rate'
        $('#shipping-rate-error').show()
        $("#shipping-rates option[value='#{data.shipping_rate}']").remove()
      else
        $('#shipping-rate-error').hide()
        img = $("#cost :first-child")[0]
        $('#cost').html('¥' + data.total_price).append(img)
        $('#shipping_span').html(" ..包含快递费#{data.shipping_rate_price}元")
    $(this).ajaxStart ->
      $('.spinner').show()
    $(this).ajaxStop ->
      $('.spinner').hide()
  .change()

  #处理订单提交结账
  $("input#complete-purchase").click ->
    $(this).attr('disabled', 'true').val '正在完成订单...'
    form = $(this).closest('form')
    action = form.attr('action')
    attrs = form.serialize()
    $.post action,attrs, (data) ->
      $("input#complete-purchase").attr('disabled', '').val '购买'
      if data.error is 'shipping_rate'
        $('#shipping-rate-error').show()
        $("#shipping-rates option[value='#{data.shipping_rate}']").remove()
      if data.payment_error is true
        $('#payment-error').show()
      if data.success is true
        window.location = data.url

    $(this).ajaxStart ->
      $('#purchase-progress').show()
    $(this).ajaxStop ->
      $('#purchase-progress').hide()

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
          options = select.attr("options")
          $("option:gt(0)", select).remove()
          $.each result, (i, item) ->
            options[options.length] = new Option(item[0], item[1])


