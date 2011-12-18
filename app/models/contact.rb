class Contact
  include ActiveModel::Validations
  include ActiveModel::Serialization

  attr_accessor :attributes
  validates_presence_of :email, :body
  validates_length_of :body, maximum: 500

  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def email
    @attributes[:email]
  end

  def body
    @attributes[:body]
  end

  def name
    @attributes[:name]
  end

  def to_query
    @attributes.to_query(:contact)
  end

end
