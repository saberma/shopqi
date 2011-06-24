App.Views.Customer.Index.Search = Backbone.View.extend
  el: '#order-filters'

  events:
    "keydown #customer-search_field": 'returnToSearch'
    "blur #customer-search_field": 'search'
    "click #customer-search_field": 'showFilter' #显示过滤器
    "change #search-filter_primary": 'selectPrimary' # 选择主过滤器
    "click #search-filter_apply": 'addFilter' # 选择主过滤器
    "click .close-filter-tag": 'removeFilter' # 删除主过滤器
    "click #search-filter_summary .remove": 'removeFilters' # 删除所有过滤器

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()
    @q = '' #避免重复查询相同内容
    @collection.bind 'refresh', -> self.render()
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

  render: ->
    $('#customer-search_msg').html("找到 #{@collection.length}位 顾客").css('background-image', 'none')

  showFilter: ->
    $('#customer-search_add_filters').show()

  returnToSearch: (e) ->
    this.search() if e.keyCode == 13

  # 执行查询(不检查重复情况)
  performSearch: ->
    hint = $('#customer-search_field').attr('data-hint')
    value = $('#customer-search_field').val()
    value = '' if value is hint
    @filters = this.getFilters @query
    params = q: value, f: _(@filters).map (filter) -> "#{filter.condition}:#{filter.value}"
    $('#customer-search_msg').html('&nbsp;').show().css('background-image', 'url(/images/spinner.gif)')
    $.get '/admin/customers/search', params, (data) -> App.customers.refresh(data)

  # 查询
  search: ->
    value = $('#customer-search_field').val()
    hint = $('#customer-search_field').attr('data-hint')
    if value != hint and @q != value
      @q = value
      this.performSearch()

  # 选择主过滤器
  selectPrimary: ->
    clazz = $('#search-filter_primary').children(':selected').attr('clazz')
    filter_html = _(secondary_filters[clazz]).map (text, value) -> "<option value='#{value}'>#{text}</option>"
    $('#search-filter_secondary').html(filter_html.join(''))
    $('#search-filter_value').val('').toggle(clazz is 'integer') #只有数值过滤器才需要额外输入框

  # 新增过滤器
  addFilter: ->
    primary = $('#search-filter_primary').children(':selected')
    secondary = $('#search-filter_secondary').children(':selected')
    text = $('#search-filter_value').val()
    is_integer = primary.attr('clazz') is 'integer'
    return false if is_integer and !text
    if is_integer
      [condition, value] = ["#{primary.val()}_#{secondary.val()}", text]
      [condition_name, value_name] = ["#{primary.text()} #{secondary.text()}", text]
    else
      [condition, value] = [primary.val(), secondary.val()]
      [condition_name, value_name] = [primary.text(), secondary.text()]
    new_filter = condition: condition, value: value, condition_name: condition_name, value_name: value_name
    @filters = this.getFilters @query
    exist_filter = _(@filters).detect (filter) -> filter.condition is new_filter.condition
    if exist_filter # 避免重复
      [exist_filter.value, exist_filter.value_name] = [new_filter.value, new_filter.value_name]
    else
      @filters.push new_filter
    @query = this.getQuery @filters
    this.showFilters()
    #App.customer_groups.add filter
    # 左右分组
    $('.customer-group.active').removeClass('active')
    $('#customergroup-current').show().addClass('active')
    this.performSearch()

  # 删除所有过滤器
  removeFilters: (e) ->
    @filters = []
    @query = ''
    this.showFilters()
    this.performSearch()
    false


  # 删除过滤器
  removeFilter: (e) ->
    remove_condition = $(e.target).parent('.filter-tag').attr('data-filter')
    @filters = this.getFilters @query
    @filters = _(@filters).reject (filter) -> filter.condition is remove_condition
    @query = this.getQuery @filters
    this.showFilters()
    this.performSearch()
    false

  #### private ####
  getFilters: (query) ->
    query = '' unless query? #TODO 与分组关联
    _(query.split(';')).compact().map (filter_query) ->
      [ condition, value, condition_name, value_name ] = filter_query.split ':'
      condition: condition, value: value, condition_name: condition_name, value_name: value_name

  getQuery: (filters) ->
    _(filters).map (filter) ->
      "#{filter.condition}:#{filter.value}:#{filter.condition_name}:#{filter.value_name}"
    .join(';')

  # 显示过滤器列表
  showFilters: ->
    $('#search-filter_summary .filter-message').text "已有#{@filters.length}个过滤器"
    $('#search-filter_summary').toggle(@filters.length > 0)
    template = Handlebars.compile $('#customer-search_filters-item').html()
    margin_top = if @filters.length > 0 then '10' else '0'
    $('#customer-search_filters').html('').css('margin-top', "#{margin_top}px")
    _(@filters).each (filter) -> $('#customer-search_filters').append template filter
