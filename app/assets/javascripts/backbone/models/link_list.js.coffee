LinkList = Backbone.Model.extend
  name: 'link_list'

  initialize: (args) ->
    #backbone.rails的initialize被覆盖，导致无法获取id，需要手动调用
    this.maybeUnwrap args
    this.with_links()

  #重载，支持子实体
  toJSON : ->
    attrs = this.wrappedAttributes()
    #手动调用_clone，因为toJSON会加wraper
    if this.links?
      links_attrs = this.links.models.map (model) ->
        _.clone model.attributes
      attrs['link_list']['links_attributes'] = links_attrs
    attrs

  #设置links关联
  with_links: ->
    if this.collection? and this.id?
      #@see http://documentcloud.github.com/backbone/#FAQ-nested
      this.links = new App.Collections.Links
      this.links.url = "#{this.collection.url}/#{this.id}/links"
      this.links.refresh this.attributes.links
      this.unset 'links', silent: true
    this

App.Collections.LinkLists = Backbone.Collection.extend
  model: LinkList
  url: '/admin/link_lists'
