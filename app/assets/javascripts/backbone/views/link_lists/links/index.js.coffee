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
    if _.isEmpty(@collection.models)
      $(@el).html "<li class='c note' style='padding-top:20px; padding-bottom:20px'>此链接列表还没有加入任何链接</li>"
    else
      @collection.each (link) -> new App.Views.LinkList.Links.Show model: link
      $(@el).sortable axis: 'y', placeholder: "sortable-placeholder", handle: '.image_handle', update: (event, ui) -> #links排序
        $.post "#{self.collection.url}/sort", $(this).sortable('serialize')
        self.cycle_class()

  cycle_class: -> # 行间隔
    self = this
    @collection.each (model) ->
      position = _.indexOf self.collection.models, model
      cycle = if position % 2 == 0 then 'odd' else 'even'
      nocycle = unless position % 2 == 0 then 'odd' else 'even'
      $(model.view.el).addClass(cycle).removeClass(nocycle)
