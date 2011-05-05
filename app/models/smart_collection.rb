class SmartCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :rules, class_name: 'SmartCollectionRule', dependent: :destroy
  has_many :products, class_name: 'SmartCollectionProduct', dependent: :destroy
  accepts_nested_attributes_for :rules, :allow_destroy => true

  before_create do
    self.handle = 'handle'
    set_default_order
  end

  after_save do
    unless self.products_order.to_sym == :manual
      # 预保存所有条件内商品记录，可以保证在修改条件时，排序不变
      # 例如，价格大于0的条件改为大于10，原有手动排序不能改变
      ids = rules_products.map(&:id)
      # 删除不匹配的商品排序记录
      products.each do |collection_product|
        unless ids.include?(collection_product.product.id)
          collection_product.destroy
        end
      end
      rules_products.each_with_index do |product, index|
        collection_product = self.products.where(product: product).first || self.products.new(product: product)
        collection_product.update_attribute :position, index
      end
    end
  end

  #找出rule相关的所有商品
  def rules_products(product_id = nil)
    conditions = self.rules.inject({}) do |results, rule|
      results["#{rule.column}_#{rule.relation}"] = rule.condition
      results
    end
    conditions.merge! meta_sort: self.products_order
    if product_id
      conditions.merge! id_equals: product_id
    end
    self.shop.products.search(conditions).all
  end

  #商品是否符合当前条件
  def match?(product)
    results = rules_products(product.id)
    !results.empty?
  end

  #默认排序
  def set_default_order
    self.products_order = KeyValues::SmartCollectionRule::Order.first.code
  end
end

class SmartCollectionRule < ActiveRecord::Base
  belongs_to :smart_collection
end

#集合关联的商品，用于手动排序
class SmartCollectionProduct < ActiveRecord::Base
  belongs_to :smart_collection
  belongs_to :product

  default_scope :order => 'position asc'
end
