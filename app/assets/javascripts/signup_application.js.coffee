#=require_self
#=require jquery
#=require jquery_ujs
#=require backbone_js
#=require plugins
#=require jquery.fancybox-1.3.4
#=require backbone/signup
#
#TODO:将工具类重构至独立的文件中
#特效
window.Effect =
  scrollTo: (id) ->
    destination = $(id).offset().top
    $("html:not(:animated),body:not(:animated)").animate {
      scrollTop: destination-20
    }, 1000

#地区
window.RegionUtils =
  init: (seed = [], region = '.region') ->
    $(region).each ->
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
            value = seed[select_index]
            select.val(value).change() if value # 级联回显
