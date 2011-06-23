App.Views.Customer.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "keydown #customer-search_field": 'returnToSearch'
    "blur #customer-search_field": 'search'
    "change .selector": 'changeCustomerCheckbox'
    "change #customer-select": 'changeCustomerSelect'
    "click #select-all": 'selectAll'
    "click #customer-search_field": 'showFilter' #显示过滤器
    "change #search-filter_primary": 'selectPrimary' # 选择主过滤器

  initialize: ->
    self = this
    _.bindAll this, 'render'
    this.render()
    @collection.bind 'refresh', -> self.render()

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

    @q = '' #避免重复查询相同内容

  render: ->
    $('#customer-search_msg').html("找到 #{App.customers.length}位 顾客").css('background-image', 'none')
    $('#customer-table_list').html('')
    _(@collection.models).each (model) ->
      new App.Views.Customer.Index.Show model: model

  showFilter: ->
    $('#customer-search_add_filters').show()

  returnToSearch: (e) ->
    if e.keyCode == 13
      this.search()

  # 查询
  search: ->
    self = $('#customer-search_field')
    value = self.val()
    hint = self.attr('data-hint')
    if value != hint and @q != value
      @q = value
      $('#customer-search_msg').html('&nbsp;').show().css('background-image', 'url(/images/spinner.gif)')
      $.get '/admin/customers/search', q: value, (data) ->
        App.customers.refresh(data)

  selectPrimary: ->
    clazz = $('#search-filter_primary').children(':selected').attr('clazz')
    filter_html = switch clazz
		    when 'tag'
		      $('#secondary-filters-price-item').html()
		    else
		      $("#secondary-filters-#{clazz}-item").html()
    $('#search-filter_secondary').html filter_html
    $('#search-filter_value').val('').toggle(clazz is 'integer') #只有数值过滤器才需要额外输入框

  # 商品复选框全选操作
  selectAll: ->
    this.$('.selector').attr 'checked', this.$('#select-all').attr('checked')
    this.changeCustomerCheckbox()

  # 商品复选框操作
  changeCustomerCheckbox: ->
    checked = this.$('.selector:checked')
    all_checked = (checked.size() == this.$('.selector').size())
    this.$('#select-all').attr 'checked', all_checked
    if checked[0]
      #已选中款式总数
      this.$('#customer-count').text "已选中 #{checked.size()} 个订单"
      $('#customer-controls').show()
    else
      $('#customer-controls').hide()

  # 操作面板修改
  changeCustomerSelect: ->
    operation = this.$('#customer-select').val()
    checked_ids = _.map this.$('.selector:checked'), (checkbox) -> checkbox.value
    $.post "/admin/customers/set", operation: operation, 'customers[]': checked_ids, ->
      document.location.href = document.location.href
    false
