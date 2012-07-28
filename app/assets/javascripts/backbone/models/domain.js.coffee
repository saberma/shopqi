App.Models.Domain = Backbone.Model.extend
  name: 'shop_domain'

  toJSON: ->
    @unset 'id'          , silent: true
    @unset 'shop_id'     , silent: true
    @unset 'is_myshopqi?', silent: true
    @unset 'verified'    , silent: true
    @wrappedAttributes()

App.Collections.Domains = Backbone.Collection.extend
  model: App.Models.Domain
  url: '/admin/domains'
