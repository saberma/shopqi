App.Models.Link = Backbone.Model.extend
  name: 'link'

App.Collections.Links = Backbone.Collection.extend
  model: App.Models.Link
  #init by link_lists
  #url: '/admin/link_lists/:link_list_id/links'
