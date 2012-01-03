class SunspotWorker # 参考http://j.mp/r64ADZ
  @queue = :solr_index

  def self.perform(sunspot_method, object = nil)
    sunspot_method = sunspot_method.to_sym
    object = object.with_indifferent_access if object.is_a? Hash

    session = Sunspot.session
    Sunspot.session = Sunspot::Rails.build_session
    case sunspot_method
    when :index
      begin
        self.index( object[:class].constantize.find(object[:id]) )
      rescue ActiveRecord::RecordNotFound
      end
    when :remove
      self.remove_by_id(object[:class], object[:id])
    when :remove_all
      self.remove_all(object)
    when :commit
      self.commit
    else
      raise "Error: undefined protocol for SunspotWorker: #{sunspot_method} (#{objects})"
    end
    Sunspot.session = session
  end

  def self.index(object)
    Sunspot.index(object)
  end

  def self.remove_by_id(klass, id)
    Sunspot.remove_by_id(klass, id)
  end

  def self.remove_all(klass = nil)
    klass = klass.constantize unless klass.nil?
    Sunspot.remove_all(klass)
  end

  def self.commit
    # on production, use autocommit in solrconfig.xml 
    # or commitWithin whenever sunspot supports it
    Sunspot.commit unless Rails.env == 'production'
  end
end
