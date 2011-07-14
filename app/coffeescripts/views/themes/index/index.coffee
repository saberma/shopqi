App.Views.Theme.Index.Index = Backbone.View.extend
  el: '#wrapper'

  events:
    "click #filter-bar a.price, #filter-bar a.color": "search"

  initialize: ->
    self = this
    this.render()
    @collection.bind 'refresh', (collection) -> self.render()

  render: ->
    self = this
    data = @collection.map (model) ->
      new App.Views.Theme.Index.Show(model: model).el.outerHTML
    .join ''
    data = "<ul>#{data}</ul>"
    $("#themes").quicksand $(data).find('li'),
      attribute: "data-id"
      useScaling: false
    , -> self.finish()
    this.finish() if @collection.length is 0 # 没有符合记录刷新页面时要显示提示

  search: (e) -> # 多条件联合查询
    current = window.location.hash.substr(1)
    query = _(current.split('&')).inject (result, item) -> #color=grey&price=free => {color: grey, price: free}
      str = item.split '='
      result[str[0]] = str[1]
      result
    , {}
    target = $(e.target).closest('a')
    query[target.attr('class')] = target.attr('rel')
    window.location = "##{$.param(query)}"
    false

  finish: -> # 查询完毕
    $(".spinner").hide()
    if @collection.length is 0
      $("#noresults").fadeIn("fast").slideDown("medium")
    else
      $("#noresults").fadeOut("fast").slideUp("fast")
