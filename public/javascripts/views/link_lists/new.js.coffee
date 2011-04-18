App.Views.Edit = Backbone.View.extend
  events:
    "submit form": "save"

  initialize: () ->
    this.render()

  save: () ->
    self = this
    this.model.save title: this.$('[name=title]').val(), body: this.$('[name=body]').val(), ->
      success: (model, resp) ->
        self.model = model
        self.render()
        self.delegateEvents()
        Backbone.history.saveLocation('documents/' + model.id)
      error: () ->
        new App.Views.Error()
      return false

  render: () ->
    out = '<form>'
    out += "<label for='title'>Title</label>"
    out += "<input name='title' type='text' />"

    out += "<label for='body'>Body</label>"
    out += "<textarea name='body'>" + (this.model.escape('body') || '') + "</textarea>"

    submitText = this.model.isNew() ? 'Create' : 'Save'

    out += "<button>" + submitText + "</button>"
    out += "</form>"

    $(this.el).html(out)
    $('#app').html(this.el)

    this.$('[name=title]').val(this.model.get('title')) // use val, for security reasons
