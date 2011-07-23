App.Views.Signup.Theme.Index = Backbone.View.extend
  el: '#themes-section'

  event:
    'click #show-more-themes': 'show'

  initialize: ->
    self = this
    this.render()

  render: ->
    self = this
    i = 0
    @collection.each (model) ->
      view = new App.Views.Signup.Theme.Show model: model
      where = if i++ < 4 then 'initial-themes' else 'more-themes'
      $("##{where}").prepend view.el
    this.$('.preview').fancybox()
    this.$(".themes .theme").each ->
      $(this).mouseenter -> $(this).children(".pick").removeClass "transparent"
      $(this).mouseleave -> $(this).children(".pick").addClass "transparent"

    #$(".pick .next").each ->
    #  $(this).click ->
    #  $(this).parents(".pick").addClass "transparent"

  show: ->
    $('#more-themes').slideDown()
    $('#show-more-themes').hide()
    false
