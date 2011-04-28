# encoding: utf-8
class SmartCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:smart_collections) { current_user.shop.smart_collections }
  expose(:smart_collection)
  expose(:products) do
    conditions = smart_collection.rules.inject({}) do |results, rule|
      results["#{rule.column}_#{rule.relation}"] = rule.condition
      results
    end
    current_user.shop.products.search(conditions).all
  end

  expose(:rule_columns) { KeyValues::SmartCollectionRule::Column.options }
  expose(:rule_relations) { KeyValues::SmartCollectionRule::Relation.options }
  expose(:rule_orders) { KeyValues::SmartCollectionRule::Order.options }
  expose(:publish_states) { KeyValues::PublishState.options }

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
    flash.now[:notice] = I18n.t("flash.actions.#{action_name}.notice")
    respond_to do |format|
      format.html { redirect_to smart_collection_path(smart_collection) }
      format.js { render :template => "shared/msg" }
    end
  end

end
