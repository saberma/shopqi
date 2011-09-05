App.Views.Signup.Theme.Show = Backbone.View.extend
  tagName: 'li'
  className: 'theme'

  events:
    'click .next': 'active'
    'mouseenter': 'show'
    'mouseleave': 'hide'

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    template = Handlebars.compile $('#theme-item').html()
    attrs = @model.attributes
    $(@el).html template attrs
    this.$('.preview').fancybox
      titlePosition: 'over'
      titleFormat: (titleStr) ->
        titleBtn = $("<a/>").addClass("btn next").html("选择此主题")
        titleBtn.click ->
          self.active()
          $.fancybox.close()
          false
        titleBtn
      onComplete: ->
        $("#fancybox-wrap").hover (->
            $("#fancybox-title").show()
          ), ->
            $("#fancybox-title").hide()

  active: ->
    $("#themes-section").slideUp()
    $("#theme-image").attr 'src', this.$('img').attr('src')
    $('#current-theme').fadeIn('slow')
    $("#selected-theme").val @model.id
    Utils.Effect.scrollTo("#shop_new")
    $("#user_name").focus()  if $("#user_name").val() is ""
    false

  show: ->
    $(@el).children(".pick").removeClass "transparent"

  hide: ->
    $(@el).children(".pick").addClass "transparent"
