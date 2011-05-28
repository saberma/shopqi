class CollectionsDrop < Liquid::Drop
  
  def frontpage
    shop.collections.where(handler: :frontpage).first
  end

end

