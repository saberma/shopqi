App.Views.Order.Show.History.Index = Backbone.View.extend
  el: '#order-history-table'

  events:
    "click .history-link": "show"

  initialize: ->
    this.render()

  render: ->
    #按日期分组 {date: [history]}
    histories = {}
    _(App.order.get('histories')).each (history) ->
      ie_date_format = Utils.Date.ie_date_format history.created_at
      created_at = new Date(ie_date_format)
      date = "#{created_at.getFullYear()}-#{created_at.getMonth() + 1}-#{created_at.getDate()}"
      histories[date] = [] unless histories[date]
      history.created_at = "#{created_at.getHours()}:#{created_at.getMinutes()}"
      histories[date].push history

    Handlebars.registerHelper 'loop', (block) ->
      _(this).map (histories, created_at) ->
        attr = created_at: created_at, histories: histories
        block(attr)
      .join('')

    template = Handlebars.compile $('#order-history-table-item').html()
    $(@el).html template histories

  show: (e)->
    self = e.target
    $.getJSON $(self).attr('href'), (data) ->
      data.body = $(self)
      new App.Views.Order.Show.History.Fulfillment data
    false
