#=require_self
#=require ./models/task
#=require ./views/tasks/checkoff
#=require ./views/tasks/show
#=require ./views/tasks/index
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
