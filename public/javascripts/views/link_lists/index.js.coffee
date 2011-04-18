App.Views.Index = Backbone.View.extend
  initialize: () ->
    this.link_lists = this.options.link_lists
    this.render()

  render: () ->
    if this.link_lists.length > 0
      out = "<h3><a href='#new'>Create New</a></h3><ul>"
      _(this.link_lists).each((item) {
        out += "<li><a href='#link_lists/" + item.id + "'>" + item.escape('title') + "</a></li>"
      })
      out += "</ul>"
    else
      out = "<h3>No link_lists! <a href='#new'>Create one</a></h3>"
    $(this.el).html(out)
    $('#app').html(this.el)
