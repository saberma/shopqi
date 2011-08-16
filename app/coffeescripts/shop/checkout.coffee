$(document).ready ->
  $('#shipping-toggle').change ->
    checked = $(this).attr('checked')
    $('#shipping').toggle !checked
    $('#shipping-same').toggle checked
  .change()

  $('#shipping-rates').change ->
    action = $(this).closest('form').attr('action')
    href = action.substr(0,action.lastIndexOf('/')) + '/update_total_price'
    $.post href, { shipping_rate: $(this).val() }, (data) ->
      img = $("#cost :first-child")[0]
      $('#cost').html(data.total_price).append(img)
    $(this).ajaxStart ->
      $('.spinner').show()
    $(this).ajaxStop ->
      $('.spinner').hide()

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
