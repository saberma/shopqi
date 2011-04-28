class SmartCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :rules, class_name: 'SmartCollectionRule', dependent: :destroy
  has_many :products, class_name: 'SmartCollectionProducts', dependent: :destroy
  accepts_nested_attributes_for :rules, :allow_destroy => true

  before_create do
    self.handle = 'handle'
  end
end

class SmartCollectionRule < ActiveRecord::Base
  belongs_to :smart_collection
end

#集合关联的商品，用于手动排序
class SmartCollectionProducts < ActiveRecord::Base
  belongs_to :smart_collection
end
