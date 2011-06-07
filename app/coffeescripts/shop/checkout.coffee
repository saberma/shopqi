$(document).ready ->
  $('#shipping-toggle').change ->
    checked = $(this).attr('checked')
    $('#shipping').toggle !checked
    $('#shipping-same').toggle checked
  .change()

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
