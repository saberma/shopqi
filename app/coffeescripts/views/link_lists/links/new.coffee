App.Views.LinkList.Links.New = Backbone.View.extend

  events:
    "click .action-link a": "add"
    "submit form": "save"
    "click .cancel": "cancel"

  initialize: ->
    log @options.link_list
    @model = new Link link_list_id: @options.link_list.id

  save: ->
    self = this
    position = @options.link_list.links.length
    @options.link_list.links.create
      position: position
      title: this.$("input[name='link[title]']").val()
      link_type: this.$("input[name='link[link_type]']").val()
      subject: this.$("input[name='link[subject]']").val()
    return false

  cancel: ->
    @$('.link').hide()
    @$('.action-row').show()
    false

  add: ->
    @$('.link').show()
    @$('.action-row').hide()
    false
