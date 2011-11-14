class Api::ProductsController < Api::AppController

  private
  def collection_serialization_options
    { include: [ :variants,:options]}
  end

  def object_serialization_options
    collection_serialization_options
  end

end
