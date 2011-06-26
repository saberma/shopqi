class CustomerGroup < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :name
end
