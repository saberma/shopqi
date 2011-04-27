class SmartCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:smart_collections) { current_user.shop.smart_collections }
  expose(:smart_collection)
  expose(:rule_columns) { KeyValues::SmartCollectionRule::Column.options }
  expose(:rule_relations) { KeyValues::SmartCollectionRule::Relation.options }
  expose(:rule_orders) { KeyValues::SmartCollectionRule::Order.options }

  def new
    #保证至少有一个条件
    smart_collection.rules << SmartCollectionRule.new if smart_collection.rules.empty?
  end

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
