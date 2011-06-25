CustomerGroup = Backbone.Model.extend
  name: 'customer_group'
  url: ->
    "/admin/customer_groups/#{this.id}"

  # 获取filter hash数组
  filters: ->
    query = this.get('query')
    query = '' unless query?
    @cache_filters ?= _(query.split(';')).compact().map (filter_query) ->
      [ condition, value, condition_name, value_name ] = filter_query.split ':'
      condition: condition, value: value, condition_name: condition_name, value_name: value_name

  # 新增filter
  addFilter: (primary, secondary, text, is_integer) ->
    if is_integer
      [condition, value] = ["#{primary.value}_#{secondary.value}", text]
      [condition_name, value_name] = ["#{primary.text} #{secondary.text}", text]
    else
      [condition, value] = [primary.value, secondary.value]
      [condition_name, value_name] = [primary.text, secondary.text]
    new_filter = condition: condition, value: value, condition_name: condition_name, value_name: value_name
    filters = this.filters()
    exist_filter = _(filters).detect (filter) -> filter.condition is new_filter.condition
    if exist_filter # 避免重复
      [exist_filter.value, exist_filter.value_name] = [new_filter.value, new_filter.value_name]
    else
      filters.push new_filter
    this.setQuery filters

  # 删除filter
  removeFilter: (remove_condition) ->
    filters = _(this.filters()).reject (filter) -> filter.condition is remove_condition
    this.setQuery filters

  # 将新的filter hash数组写入query
  setQuery: (filters) ->
    @cache_filters = filters
    query = _(filters).map (filter) ->
      "#{filter.condition}:#{filter.value}:#{filter.condition_name}:#{filter.value_name}"
    .join(';')
    this.set query: query
