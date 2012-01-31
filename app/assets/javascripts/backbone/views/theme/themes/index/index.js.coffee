App.Views.Theme.Themes.Index.Index = Backbone.View.extend
  el: '#wrapper'

  events:
    "click #filter-bar a.price, #filter-bar a.color": "search"

  initialize: ->
    self = this
    this.render()
    @collection.bind 'refresh', (collection) -> self.render()

  render: ->
    self = this
    data = $('<ul/>')
    @collection.each (model) -> data.append new App.Views.Theme.Themes.Index.Show(model: model).el
    $("#themes").quicksand $(data).find('li'),
      attribute: "data-id"
      useScaling: false
    , -> self.finish()
    @finish() if @collection.length is 0 or $('.ie6')[0] # 没有符合记录刷新页面时要显示提示, ie6没有调用callback

  search: (e) -> # 多条件联合查询
    current = window.location.hash.substr(1)
    items = _.compact current.split('&')
    query = _(items).inject (result, item) -> #color=grey&price=free => {color: grey, price: free}
      str = item.split '='
      result[str[0]] = str[1]
      result
    , {}
    target = $(e.target).closest('a')
    query[target.attr('class')] = target.attr('rel')
    window.location = "##{$.param(query)}"
    false

  finish: -> # 查询完毕
    if $(".spinner:visible")[0] # 避免重复执行
      $(".spinner").hide()
      if @collection.length is 0
        $("#noresults").fadeIn("fast").slideDown("medium")
      else
        $("#noresults").fadeOut("fast").slideUp("fast")
