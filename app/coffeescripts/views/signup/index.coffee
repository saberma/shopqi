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
    self = this
    attrs = _.reduce $('form').serializeArray(), (result, obj) ->
      name = obj.name.replace('shop\[', 'user[shop_attributes][')
      name = name.replace('domain\[', 'user[shop_attributes][domains_attributes][][')
      result[name] = obj.value
      result
    , {}
    $.post '/user', attrs, (data) ->
      location = '/admin'
