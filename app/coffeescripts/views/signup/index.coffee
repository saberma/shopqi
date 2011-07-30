App.Views.Signup.Index = Backbone.View.extend
  el: '#wrapper'

  events:
    "submit #shop_new": "save"
    "click #check_phone": "get_verify_code"

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
    last_domain = this.get_domain()
    template = Handlebars.compile $('#available-item').html()
    setInterval -> # 定时检测域名有效性
      domain = self.get_domain()
      subdomain = $('#domain_subdomain').val()
      if subdomain isnt ''
        if subdomain.length >= 4
          if domain isnt last_domain
            last_domain = domain
            $('#spinner').css('display', '') # show方法会导致移位
            $.get '/services/signup/check_availability', domain: domain, (data) ->
              attrs = available: (data is 'true'), domain: domain
              $('#spinner').hide()
              $('#domain-available').html template attrs
        else
          $('#domain-available').html "<span class='negative'>子域名最少需要4个字符<span>"
    , 2000

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
        else # 有错误
          errors = {}
          errors['shop.domains.host'] = "商店Web地址已经存在" if data['shop.domains.host']?
          errors['email'] = "Email地址已经注册" if data.email?
          errors['password'] = "密码与确认密码需要保持一致，长度不能少于6个字符" if data.password?
          errors['verify_code'] = "手机校验码不正确" if data.verify_code?
          self.message errors
          self.reset()
    else # 校验不通过
      self.reset()
    false

  ###### private methods #####
  validate: ->
    check_list =
      shop_name: '请给您的商店取个名字'
      domain_subdomain: '请为您的商店挑选Web地址'
    errors = {}
    _(check_list).each (msg, key) ->
      errors[key] = msg if $("##{key}").val() is ''
    if _.isEmpty errors
      empty_check_list = ['user_name', 'shop_province', 'shop_city', 'shop_district', 'shop_address', 'shop_zipcode', 'shop_phone', 'user_email', 'user_password', 'user_password_confirmation', 'user_phone', 'phone_verify_code']
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
    this.message errors
    _.isEmpty errors

  message: (errors) -> # 显示错误提示
    result = _.isEmpty errors
    $('#errorExplanation p').remove()
    _(errors).each (msg, key) -> $('#errorExplanation').append "<p>#{msg}</p>"
    $('#errorExplanation').toggle(!result)
    Effect.scrollTo("#errorExplanation") unless result

  reset: ->
    $('#shop_submit').attr('disabled', false).val '创建我的ShopQi商店'

  get_domain: ->
    "#{$('#domain_subdomain').val()}#{$('#domain_domain').val()}"

  get_verify_code: ->
    phone = $('#user_phone').val()
    if this.is_mobile phone
      $('#check_phone').attr('disabled', true)
      $('#user_phone_hint').hide()
      $.post '/services/signup/verify_code', phone: phone, ->
        i = 60
        timerId = setInterval ->
          if i is 0
            clearInterval timerId
            $('#check_phone').attr('disabled', false).val "获取验证码"
          else
            $('#check_phone').val "已发送,请检查短信(如未收到,#{i--}秒后可重新获取)"
        , 1000
    else
      $('#user_phone_hint').hide().fadeIn()

  is_mobile: (phone) ->
    patten= /^[1]([3][0-9]{1}|59|58|88|89)[0-9]{8}$/
    return false if !patten.exec(phone)
    true
