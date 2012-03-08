#=require_self
#=require_tree ./models
#=require_tree ./views/tasks
#=require_tree ./views/products
#=require_tree ./views/product_options
#=require_tree ./views/orders
#=require_tree ./views/customers
#=require_tree ./views/customer_groups
#=require_tree ./views/custom_collections
#=require_tree ./views/link_lists
#=require_tree ./views/themes
#=require_tree ./views/users
#=require_tree ./views/domains
#=require_tree ./views/assets
#=require_tree ./views/comments
#=require_tree ./views/payments
#=require_tree ./views/shippings
#=require_tree ./views/api_clients
#=require_tree ./controllers/orders
#=require_tree ./controllers/customers
#=require ./controllers/products
#=require ./controllers/smart_collections
#=require ./controllers/custom_collections
#=require ./controllers/pages
#=require ./controllers/users
#=require ./controllers/comments
#=require ./controllers/emails
#=require ./controllers/articles

window.App =
  Models: {}
  Views:
    User: {}
    ApiClient: {}
    LinkList:
      Links: {}
    Link: {}
    SmartCollection: {}
    CustomCollection: {}
    Order:
      Index: {}
      Show:
        Transaction: {}
        Fulfillment: {}
        LineItem: {}
        History: {}
    Customer:
      Index:
        Filter: {}
      Show:
        Order: {}
      New: {}
    CustomerGroup:
      Index: {}
    Asset:
      Index: {}
    Theme:
      Settings:
        Preset: {}
    Product:
      Show:
        Variant: {}
      Index: {}
    Comment: {}
    Payment: {}
    Shipping:
      WeightBasedShippingRates: {}
      PriceBasedShippingRates: {}
    ProductOption: {}
    Task: {}
    Domain: {}
  Controllers:
    Orders: {}
    Customers: {}
  Collections: {}
  init: ->
