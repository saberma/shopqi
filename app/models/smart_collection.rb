# encoding: utf-8
class SmartCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :rules   , class_name: 'SmartCollectionRule'   , dependent: :destroy
  has_many :collection_products, dependent: :destroy          , class_name: 'SmartCollectionProduct'
  has_many :products           , through: :collection_products
  validates_presence_of :title
  accepts_nested_attributes_for :rules, allow_destroy: true

  before_save do
    self.handle = Pinyin.t(self.title) if self.handle.blank? # 新增时初始化handle
    self.handle = Handle.make_valid(shop.smart_collections, self.handle)
    set_default_order
  end

  after_save do
    unless self.products_order.to_sym == :manual
      # 预保存所有条件内商品记录，可以保证在修改条件时，排序不变
      # 例如，价格大于0的条件改为大于10，原有手动排序不能改变
      ids = rules_products.map(&:id)
      # 删除不匹配的商品排序记录
      collection_products.each do |collection_product|
        unless ids.include?(collection_product.product.id)
          collection_product.destroy
        end
      end
      rules_products.each_with_index do |product, index|
        collection_product = self.collection_products.where(product_id: product).first || self.collection_products.new(product: product)
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
    conditions.merge! id_equals: product_id if product_id # 用于检查某个商品是否符合条件
    self.shop.products.metasearch(conditions).all
  end

  #商品是否符合当前条件
  def match?(product)
    results = rules_products(product.id)
    !results.empty?
  end

  #默认排序
  def set_default_order
    self.products_order = KeyValues::Collection::Order.first.code
  end

  #规则信息
  def rules_info
    rules.map(&:info).join ' 并且 '
  end
end

class SmartCollectionRule < ActiveRecord::Base
  belongs_to :smart_collection

  def info
    column_name = KeyValues::Collection::Column.find_by_code(self.column).name
    relation_name = KeyValues::Collection::Relation.find_by_code(self.relation).name
    "#{column_name} #{relation_name} #{self.condition}"
  end
end

#集合关联的商品
class SmartCollectionProduct < ActiveRecord::Base
  belongs_to :smart_collection
  belongs_to :product

  default_scope order: 'position asc'
end
