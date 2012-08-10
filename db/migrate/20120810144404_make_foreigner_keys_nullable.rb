class MakeForeignerKeysNullable < ActiveRecord::Migration
  def up # #465
    Activity.where(shop_id: nil).destroy_all
    [CustomCollection, SmartCollection]
    CustomCollectionProduct.where(product_id: nil).destroy_all
    SmartCollectionProduct.where(product_id: nil).destroy_all
    PriceBasedShippingRate.where(shipping_id: nil).destroy_all
    WeightBasedShippingRate.where(shipping_id: nil).destroy_all
    change_column :activities                 , :shop_id             , :integer, null: false
    change_column :api_clients                , :shop_id             , :integer, null: false
    change_column :articles                   , :shop_id             , :integer, null: false
    change_column :articles                   , :blog_id             , :integer, null: false
    change_column :blogs                      , :shop_id             , :integer, null: false
    change_column :comments                   , :shop_id             , :integer, null: false
    change_column :comments                   , :article_id          , :integer, null: false
    change_column :consumptions               , :shop_id             , :integer, null: false
    change_column :custom_collection_products , :custom_collection_id, :integer, null: false
    change_column :custom_collection_products , :product_id          , :integer, null: false
    change_column :custom_collections         , :shop_id             , :integer, null: false
    change_column :discounts                  , :shop_id             , :integer, null: false
    change_column :emails                     , :shop_id             , :integer, null: false
    change_column :link_lists                 , :shop_id             , :integer, null: false
    change_column :links                      , :link_list_id        , :integer, null: false
    change_column :order_discounts            , :order_id            , :integer, null: false
    change_column :order_line_items           , :product_id          , :integer, null: false
    change_column :pages                      , :shop_id             , :integer, null: false
    change_column :payments                   , :shop_id             , :integer, null: false
    change_column :photos                     , :product_id          , :integer, null: false
    change_column :price_based_shipping_rates , :shipping_id         , :integer, null: false
    change_column :weight_based_shipping_rates, :shipping_id         , :integer, null: false
    change_column :shippings                  , :shop_id             , :integer, null: false
    change_column :shop_domains               , :shop_id             , :integer, null: false
    change_column :shop_policies              , :shop_id             , :integer, null: false
    change_column :shop_product_types         , :shop_id             , :integer, null: false
    change_column :shop_product_vendors       , :shop_id             , :integer, null: false
    change_column :shop_tasks                 , :shop_id             , :integer, null: false
    change_column :shop_themes                , :shop_id             , :integer, null: false
    change_column :smart_collection_products  , :smart_collection_id , :integer, null: false
    change_column :smart_collection_products  , :product_id          , :integer, null: false
    change_column :smart_collection_rules     , :smart_collection_id , :integer, null: false
    change_column :smart_collections          , :shop_id             , :integer, null: false
    change_column :subscribes                 , :shop_id             , :integer, null: false
    change_column :users                      , :shop_id             , :integer, null: false
    change_column :webhooks                   , :shop_id             , :integer, null: false
  end

  def down
    change_column :activities                 , :shop_id             , :integer, null: true
    change_column :api_clients                , :shop_id             , :integer, null: true
    change_column :articles                   , :shop_id             , :integer, null: true
    change_column :articles                   , :blog_id             , :integer, null: true
    change_column :blogs                      , :shop_id             , :integer, null: true
    change_column :comments                   , :shop_id             , :integer, null: true
    change_column :comments                   , :article_id          , :integer, null: true
    change_column :consumptions               , :shop_id             , :integer, null: true
    change_column :custom_collection_products , :custom_collection_id, :integer, null: true
    change_column :custom_collection_products , :product_id          , :integer, null: true
    change_column :custom_collections         , :shop_id             , :integer, null: true
    change_column :discounts                  , :shop_id             , :integer, null: true
    change_column :emails                     , :shop_id             , :integer, null: true
    change_column :link_lists                 , :shop_id             , :integer, null: true
    change_column :links                      , :link_list_id        , :integer, null: true
    change_column :order_discounts            , :order_id            , :integer, null: true
    change_column :order_line_items           , :product_id          , :integer, null: true
    change_column :pages                      , :shop_id             , :integer, null: true
    change_column :payments                   , :shop_id             , :integer, null: true
    change_column :photos                     , :product_id          , :integer, null: true
    change_column :price_based_shipping_rates , :shipping_id         , :integer, null: true
    change_column :weight_based_shipping_rates, :shipping_id         , :integer, null: true
    change_column :shippings                  , :shop_id             , :integer, null: true
    change_column :shop_domains               , :shop_id             , :integer, null: true
    change_column :shop_policies              , :shop_id             , :integer, null: true
    change_column :shop_product_types         , :shop_id             , :integer, null: true
    change_column :shop_product_vendors       , :shop_id             , :integer, null: true
    change_column :shop_tasks                 , :shop_id             , :integer, null: true
    change_column :shop_themes                , :shop_id             , :integer, null: true
    change_column :smart_collection_products  , :smart_collection_id , :integer, null: true
    change_column :smart_collection_products  , :product_id          , :integer, null: true
    change_column :smart_collection_rules     , :smart_collection_id , :integer, null: true
    change_column :smart_collection           , :shop_id             , :integer, null: true
    change_column :subscribes                 , :shop_id             , :integer, null: true
    change_column :users                      , :shop_id             , :integer, null: true
    change_column :webhooks                   , :shop_id             , :integer, null: true
  end
end
