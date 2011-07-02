module HomeHelper
  def url_for_lookup(clazz,record, options = {})
    if clazz == Article
      polymorphic_url([record.blog,record], options)
    else
      polymorphic_url(record, options)
    end
  end
end
