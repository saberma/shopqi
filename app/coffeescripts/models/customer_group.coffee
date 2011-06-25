CustomerGroup = Backbone.Model.extend
  name: 'customer_group'
  url: ->
    "/admin/customer_groups/#{this.id}"

  # 获取filter hash数组
  filters: ->
    query = this.get('query')
    query = '' unless query?
    _(query.split(';')).compact().map (filter_query) ->
      [ condition, value, condition_name, value_name ] = filter_query.split ':'
      condition: condition, value: value, condition_name: condition_name, value_name: value_name

  # 将新的filter hash数组写入query
  setQuery: (filters) ->
    query = filters.map (filter) ->
      "#{filter.get('condition')}:#{filter.get('value')}:#{filter.get('condition_name')}:#{filter.get('value_name')}"
    .join(';')
    this.set query: query

# 辅助实体，后端应用不需要相应的实体
CustomerGroupFilter = Backbone.Model.extend
  name: 'customer_group_filter'
