class RemoveDestroyedSmartCollectionProduct < ActiveRecord::Migration
  def up
    SmartCollection
    SmartCollectionProduct.all.select{|smart_collection_product| smart_collection_product.product.nil? }.map(&:destroy)
  end

  def down
  end
end
