App.Views.LinkList.Index = Backbone.View.extend
  initialize: () ->
    this.link_lists = this.options.link_lists
    this.render()

  render: () ->
    #if this.link_lists.length > 0
    #  out = "<h3><a href='#new'>Create New</a></h3><ul>"
    #  _(this.link_lists).each((item) {
    #    out += "<li><a href='#link_lists/" + item.id + "'>" + item.escape('title') + "</a></li>"
    #  })
    #  out += "</ul>"
    #$(this.el).html(out)
    #$('#app').html(this.el)
