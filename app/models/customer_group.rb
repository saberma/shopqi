class CustomerGroup < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :name

  attr_accessible :id, :name, :query, :term

  default_value_for :term, ''
  default_value_for :query, ''
end
