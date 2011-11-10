namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

namespace 'Utils', (exports) ->
  #地区
  exports.Region =
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
      #日期
  exports.Date =
        to_s: (date, format='yyyy-MM-dd HH:mm:ss') ->
          date = new Date(date)
          text = format.replace /yyyy/, date.getFullYear()
          text = text.replace /MM/, this.prefix(date.getMonth() + 1)
          text = text.replace /dd/, this.prefix(date.getDate())
          text = text.replace /HH/, this.prefix(date.getHours())
          text = text.replace /mm/, this.prefix(date.getMinutes())
          text.replace /ss/, this.prefix(date.getSeconds())

        formatDate: (date) ->
          this.to_s date, 'yyyy-MM-dd'

        prefix: (text) ->
          if "#{text}".length == 1 then "0#{text}" else text
    #表单
  exports.Form =
      #表单输入项转化为hash: option1 => value
      to_h: (form) ->
        inputs = {}
        $(':input', form).each ->
          #product_variant[option1] => option1
          name = $(this).attr('name')
          match = name.match(/.+\[(.+)\]/)
          return true unless match
          # 单选项
          return true if $(this).attr('type') in ['radio', 'checkbox'] and ($(this).attr('checked') isnt 'checked')
          field = match[1]
          inputs[field] = $(this).val()
        inputs
  #标签
  exports.Tag =
    init: (tags_text_id = 'tags_text', tag_list_id = 'tag-list')->
      text_field = $("##{tags_text_id}")
      tag_items = $("##{tag_list_id} a")
      tag_items.click ->
        $(this).toggleClass('active-tag')
        tags = StringUtils.to_a(text_field.val())
        tag = $(this).text()
        if tag not in tags
          tags.push tag
        else
          tags = _.without tags, tag
        text_field.val(tags.join(', '))
        false
      text_field.keyup ->
        tags = StringUtils.to_a(text_field.val())
        tag_items.each ->
          if $(this).text() in tags
            $(this).addClass('active-tag')
          else
            $(this).removeClass('active-tag')
      .keyup()
  #特效
  exports.Effect =
    scrollTo: (id) ->
      destination = $(id).offset().top
      $("html:not(:animated),body:not(:animated)").animate {
        scrollTop: destination-20
      }, 1000

  exports.markFeaturedImage = ->
    $('.featured').remove()
    $('div#image-show-area ul li:first-child').append("<div class='featured'></div>")
