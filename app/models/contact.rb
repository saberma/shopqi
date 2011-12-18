class Contact
  include ActiveModel::Validations
  include ActiveModel::Serialization

  attr_accessor :attributes, :name, :email, :body
  validates_presence_of :email, :body

  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def to_query
    @attributes.to_query(:contact)
  end

end
