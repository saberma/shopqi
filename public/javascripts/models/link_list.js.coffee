LinkList = Backbone.Model.extend
  url : ->
    base = 'link_lists'
    if this.isNew() return base
    base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id
