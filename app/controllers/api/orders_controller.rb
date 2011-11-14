class Api::OrdersController < Api::AppController

  private
  def collection_serialization_options
    { include: [:line_items,:shipping_address,:customer,:fulfillments,:histories]}
  end

  def object_serialization_options
    collection_serialization_options
  end
end
