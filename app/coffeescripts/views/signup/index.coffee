App.Views.Signup.Index = Backbone.View.extend
  el: '#wrapper'

  events:
    "submit #shop_new": "save"

  initialize: ->
    self = this
    this.render()
    RegionUtils.init()
    $("#shop_name").focus()
    inputFields = $("input.input-text")
    setInterval ->
      inputFields.each -> $("label[for='#{@id}']").addClass "has-text"  unless @value is ""
    , 200
    $("input.input-text").each ->
      $(this).focus -> $("label[for='#{@id}']").addClass "focus"
      $(this).keypress -> $("label[for='#{@id}']").addClass("has-text").removeClass 'focus'
      $(this).blur -> $("label[for='#{@id}']").removeClass("has-text").removeClass('focus') if @value is ""

  render: ->
    self = this
    new App.Views.Signup.Theme.Index collection: App.themes

  save: ->
    $('#shop_submit').attr('disabled', true).val '正在创建您的商店...'
    self = this
    if this.validate()
      attrs = _.reduce $('form').serializeArray(), (result, obj) ->
        name = obj.name.replace('shop\[', 'user[shop_attributes][')
        name = name.replace('domain\[', 'user[shop_attributes][domains_attributes][][')
        result[name] = obj.value
        result
      , {}
      $.post '/user', attrs, (data) ->
        if _.isEmpty data
          window.location = '/admin'
        else
          self.reset()
    else
      self.reset()
    false

  validate: ->
    $('#errorExplanation p').remove()
    check_list =
      shop_name: '请给您的商店取个名字'
      domain_subdomain: '请为您的商店挑选Web地址'
    errors = {}
    _(check_list).each (msg, key) ->
      errors[key] = msg if $("##{key}").val() is ''
    if _.isEmpty errors
      empty_check_list = ['user_name', 'shop_province', 'shop_city', 'shop_district', 'shop_address', 'shop_zipcode', 'shop_phone', 'user_email', 'user_password', 'user_password_confirmation', 'user_phone']
      _(empty_check_list).each (key) ->
        if $("##{key}").val() is ''
          text = switch $("##{key}").attr('type')
            when 'select-one'
              $("##{key}").children('option:first').text().substr(2,2)
            else #'text'
              $("label[for='#{key}']").text()
          errors[key] = "#{text} 不能为空"
      unless $('#shop_terms_and_conditions').attr('checked')
        errors['shop_terms_and_conditions'] = "请您先阅读并接受服务条款"
    _(errors).each (msg, key) -> $('#errorExplanation').append "<p>#{msg}</p>"
    result = _.isEmpty errors
    $('#errorExplanation').toggle(!result)
    Effect.scrollTo("#errorExplanation") unless result
    result

  reset: ->
    $('#shop_submit').attr('disabled', false).val '创建我的ShopQi商店'
