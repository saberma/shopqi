class SmartCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:smart_collections) { current_user.shop.smart_collections }
  expose(:smart_collection)
  expose(:rule_columns) { KeyValues::SmartCollectionRule::Column.all }
  expose(:rule_relations) { KeyValues::SmartCollectionRule::Relation.all }

end
