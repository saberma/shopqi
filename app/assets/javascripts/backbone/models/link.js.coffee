App.Models.Link = Backbone.Model.extend
  name: 'link'

  toJSON : ->
    @unset 'link_list_id', silent: true
    @wrappedAttributes()

App.Collections.Links = Backbone.Collection.extend
  model: App.Models.Link
  #init by link_lists
  #url: '/admin/link_lists/:link_list_id/links'
