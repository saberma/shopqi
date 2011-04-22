LinkList = Backbone.Model.extend
  name: 'link_list'

  initialize: (args) ->
    #backbone.rails的initialize被覆盖，导致无法获取id，需要手动调用
    this.maybeUnwrap args
    #@see http://documentcloud.github.com/backbone/#FAQ-nested
    this.links = new App.Collections.Links
    this.links.url = "#{this.collection.url}/#{this.id}/links"
    this.links.refresh this.attributes.links
    this.unset 'links', silent: true
