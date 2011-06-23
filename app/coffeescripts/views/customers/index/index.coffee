App.Views.Customer.Index.Index = Backbone.View.extend
  el: '#main'

  events:
    "keydown #customer-search_field": 'returnToSearch'
    "blur #customer-search_field": 'search'
    "change .selector": 'changeCustomerCheckbox'
    "change #customer-select": 'changeCustomerSelect'
    "click #select-all": 'selectAll'

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

    @q = '' #避免重复查询相同内容

  render: ->
    $('#customer-table_list').html('')
    _(@collection.models).each (model) ->
      new App.Views.Customer.Index.Show model: model

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
      $('#customer-search_msg').show().css('background-image', 'url(/images/spinner.gif)')
      $.get '/admin/customers/search', q: value, (data) ->
        $('#customer-search_msg').css('background-image', 'none')
        App.customers.refresh(data)

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
