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
    @model = App.customer_group
    self = this
    @q = '' #避免重复查询相同内容
    App.customer_group.bind 'change', -> self.performSearch()
    App.customer_group.bind 'change:query', -> self.showFilters()
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

  showFilter: ->
    $('#customer-search_add_filters').show()

  returnToSearch: (e) ->
    this.search() if e.keyCode == 13

  # 执行查询(不检查重复情况)
  performSearch: ->
    hint = $('#customer-search_field').attr('data-hint')
    value = $('#customer-search_field').val()
    value = '' if value is hint
    params = q: value, f: _(@model.filters()).map (filter) -> "#{filter.condition}:#{filter.value}"
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
    @model.addFilter {value: primary.val(), text: primary.text()}, {value: secondary.val(), text: secondary.text()}, text, is_integer
    # 左右分组
    $('.customer-group.active').removeClass('active')
    $('#customergroup-current').show().addClass('active')

  # 删除所有过滤器
  removeFilters: (e) ->
    @model.setQuery []
    false


  # 删除过滤器
  removeFilter: (e) ->
    remove_condition = $(e.target).parent('.filter-tag').attr('data-filter')
    @model.removeFilter remove_condition
    false

  # 显示过滤器列表
  showFilters: ->
    filters = @model.filters()
    $('#search-filter_summary .filter-message').text "已有#{filters.length}个过滤器"
    $('#search-filter_summary').toggle(filters.length > 0)
    template = Handlebars.compile $('#customer-search_filters-item').html()
    margin_top = if filters.length > 0 then '10' else '0'
    $('#customer-search_filters').html('').css('margin-top', "#{margin_top}px")
    _(filters).each (filter) -> $('#customer-search_filters').append template filter
