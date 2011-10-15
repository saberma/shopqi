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
#=require_tree ./views/domains
#=require_tree ./views/assets
#=require_tree ./controllers/orders
#=require_tree ./controllers/customers
#=require ./controllers/products
#=require ./controllers/smart_collections
#=require ./controllers/custom_collections

window.App =
  Models: {}
  Views:
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
    ProductOption: {}
    Task: {}
    Domain: {}
  Controllers:
    Orders: {}
    Customers: {}
  Collections: {}
  init: ->
