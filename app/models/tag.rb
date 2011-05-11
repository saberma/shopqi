class Tag < ActiveRecord::Base
  belongs_to :shop
  has_and_belongs_to_many :product
end

#商品标签
#class ProductTag < ActiveRecord::Base
#  belongs_to :tag
#  belongs_to :product
#end
