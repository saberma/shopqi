$(document).ready ->
  $('#action a').click ->
    $('#add_address').toggle()
    return false

  #新增地址处的toggle
  $(".note a[href='#']").each ->
    $(this).click ->
      $(this).closest('form').parent().toggle()
      return false

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


