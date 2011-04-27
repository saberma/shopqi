class SmartCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:smart_collections) { current_user.shop.smart_collections }
  expose(:smart_collection)
  expose(:rule_columns) { KeyValues::SmartCollectionRule::Column.all }
  expose(:rule_relations) { KeyValues::SmartCollectionRule::Relation.all }
  expose(:rule_orders) { KeyValues::SmartCollectionRule::Order.all }

  def create
    smart_collection.save
    redirect_to smart_collection_path(smart_collection)
  end

  def update
    smart_collection.save
    respond_to do |format|
      format.html { redirect_to smart_collection_path(smart_collection) }
      format.js
    end
  end

end
