App.Views.LinkList.Links.Index = Backbone.View.extend

  initialize: ->
    self = this
    @collection.view = this
    @collection.bind 'remove', (model) -> self.render() # 编辑时只删除记录也要更新
    @render()
    @cycle_class()

  render: ->
    self = this
    $(@el).html ''
    @collection.each (link) -> new App.Views.LinkList.Links.Show model: link
    $(@el).sortable axis: 'y', placeholder: "sortable-placeholder", handle: '.image_handle', update: (event, ui) -> #links排序
      $.post "#{self.collection.url}/sort", $(this).sortable('serialize')
      #排序后设置到model
      ids = _.map $(this).sortable('toArray'), (id) -> id.substr(5) #link_1
      i = 0
      _.each ids, (id) -> self.collection.get(id).set { position: i++ }, silent: true
      self.collection.sort silent: true
      self.cycle_class()

  cycle_class: -> # 行间隔
    self = this
    @collection.each (model) ->
      position = _.indexOf self.collection.models, model
      cycle = if position % 2 == 0 then 'odd' else 'even'
      nocycle = unless position % 2 == 0 then 'odd' else 'even'
      $(model.view.el).addClass(cycle).removeClass(nocycle)
