LinkList = Backbone.Model.extend
  name: 'link_list'
  url : ->
    base = 'link_lists'
    if this.isNew() then return base
    base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id
