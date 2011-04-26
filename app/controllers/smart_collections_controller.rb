class SmartCollectionsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:smart_collections) { current_user.shop.smart_collections }
  expose(:smart_collection)

end
