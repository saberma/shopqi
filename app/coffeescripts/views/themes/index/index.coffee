App.Views.Theme.Index.Index = Backbone.View.extend
  el: '#wrapper'

  events:
    "click #filter-bar a.price, #filter-bar a.color": "search"

  initialize: ->
    self = this
    this.render()
    @collection.bind 'refresh', (collection) -> self.render()

  render: ->
    data = @collection.map (model) ->
      new App.Views.Theme.Index.Show(model: model).el.outerHTML
    .join ''
    data = "<ul>#{data}</ul>"
    $("#themes").quicksand $(data).find('li'),
      attribute: "data-id"
      useScaling: false

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
