class SmartCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :rules, class_name: 'SmartCollectionRule', dependent: :destroy
  accepts_nested_attributes_for :rules, :allow_destroy => true

  before_create do
    self.handle = 'handle'
  end
end

class SmartCollectionRule < ActiveRecord::Base
  belongs_to :smart_collection
end
