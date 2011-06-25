App.Views.Customer.Index.Search = Backbone.View.extend
  el: '#customer-filters'

  events:
    "keydown #customer-search_field": 'returnToSearch'
    "blur #customer-search_field": 'blurToSearch'

  initialize: ->
    self = this
    @model = App.customer_group
    @model.bind 'change', -> self.render()
    # 未输入内容时显示提示
    $("input[data-hint]").focus ->
      hint = $(this).attr('data-hint')
      $(this).css color: ''
      $(this).val('') if $(this).val() == hint
    .blur ->
      hint = $(this).attr('data-hint')
      $(this).val(hint).css(color: '#888') unless $(this).val()
    .blur()
    # 初始化过滤器
    $('#search-filter_primary').change()

  # 显示过滤器列表
  render: ->
    hint = $('#customer-search_field').attr('data-hint')
    value = $('#customer-search_field').val()
    unless !@model.get('term') and value is hint
      $('#customer-search_field').val @model.get('term')
    new App.Views.Customer.Index.Filter.Index model: @model
    this.search()

  returnToSearch: (e) ->
    this.blurToSearch() if e.keyCode == 13 # 回车

  blurToSearch: ->
    hint = $('#customer-search_field').attr('data-hint')
    value = $('#customer-search_field').val()
    if value and value isnt hint
      @model.set term: value

  # 查询
  search: ->
    [value, filters] = [@model.get('term'), @model.filters()]
    value = '' unless value
    params = q: value, f: _(filters).map (filter) -> "#{filter.condition}:#{filter.value}"
    $('#customer-search_msg').html('&nbsp;').show().css('background-image', 'url(/images/spinner.gif)')
    $.get '/admin/customers/search', params, (data) -> App.customers.refresh(data)
    # 左边分组
    unless @model.id
      empty_condition = !value and _.isEmpty(filters) # 所有顾客 且 没有查询关键字和过滤条件
      $('#customergroup-all').toggleClass('active', empty_condition)
      $('#customergroup-current').toggle(!empty_condition).toggleClass('active', !empty_condition)
