App.Views.Customer.Index.Search = Backbone.View.extend
  el: '#order-filters'

  events:
    "keydown #customer-search_field": 'returnToSearch'
    "blur #customer-search_field": 'search'
    "click #customer-search_field": 'showFilter' #显示过滤器
    "change #search-filter_primary": 'selectPrimary' # 选择主过滤器
    "click #search-filter_apply": 'addFilter' # 选择主过滤器

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
    $('#customer-search_msg').html('&nbsp;').show().css('background-image', 'url(/images/spinner.gif)')
    $.get '/admin/customers/search', q: value, (data) -> App.customers.refresh(data)

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
    primary = $('#search-filter_primary').children(':selected').val()
    secondary = $('#search-filter_secondary').children(':selected').val()
    query_name = "#{$('#search-filter_primary').children(':selected').text()} #{$('#search-filter_secondary').children(':selected').text()}"
    filter = name: '', query: "{#{primary}:#{secondary}}", query_name: query_name
    App.customer_groups.add filter
    # 显示新增的过滤器
    $('#search-filter_summary .filter-message').text "已有1个过滤器"
    $('#search-filter_summary').show()
    template = Handlebars.compile $('#customer-search_filters-item').html()
    $('#customer-search_filters').css('margin-top', '10px').append template filter
    # 左右分组
    $('.customer-group.active').removeClass('active')
    $('#customergroup-current').show().addClass('active')
    this.performSearch()
