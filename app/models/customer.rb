# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_many :orders
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress', order: :id.asc
  has_and_belongs_to_many :tags, class_name: 'CustomerTag'

  accepts_nested_attributes_for :addresses
  attr_accessible :name, :email, :note, :accepts_marketing, :tags_text, :addresses_attributes

  validates_presence_of :name, :email
  validates_uniqueness_of :email, scope: :shop_id, allow_blank: true

  # 标签
  attr_accessor :tags_text

  default_value_for :status, 'enabled'

  def tags_text
    @tags_text ||= self.tags.map(&:name).join(', ')
  end

  def available_orders # 有效订单
    self.orders.where(financial_status: [:paid, :pending, :authorized])
  end

  # 默认地址
  def address
    json = addresses.first.as_json(methods: [:province_name, :city_name, :district_name])
    json['customer_address']
  end

  # 首次下单
  def order
    self.available_orders.first.as_json['order']
  end

  def status_name
    KeyValues::Customer::State.find_by_code(status).name
  end

  # 加入地址(不能重复)
  def add_address(a) #a可以是billing_address或者shipping_address
    attrs = { name: a.name, company: a.company, country_code: a.country_code, province: a.province, city: a.city,
              district: a.district, address1: a.address1, address2: a.address2, zip: a.zip, phone: a.phone }
    unless self.addresses.exists?(attrs)
      self.addresses.create attrs
    end
  end

  after_save do
    added_tags = self.tags.map(&:name)
    shop_tags = shop.customer_tags
    tag_class = CustomerTag
    # 删除tag
    (added_tags - tag_class.split(tags_text)).each do |tag_text|
      tag = shop_tags.where(name: tag_text).first
      tags.delete(tag)
    end
    # 新增tag
    (tag_class.split(tags_text) - added_tags).each do |tag_text|
      tag = shop_tags.where(name: tag_text).first
      if tag
        tag.touch # 更新时间，用于显示最近使用过的标签
      else
        tag = shop_tags.create(name: tag_text)
      end
      self.tags << tag
    end
  end
end

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer

  before_create do
    self.name = self.customer.name if self.name.blank?
  end

  def province_name
    District.get(self.province)
  end

  def city_name
    District.get(self.city)
  end

  def district_name
    District.get(self.district)
  end
end

class CustomerTag < ActiveRecord::Base
  belongs_to :shop
  has_and_belongs_to_many :customer
  # 最近使用过的标签
  scope :previou_used, order: :updated_at.desc, limit: 10

  # 分隔逗号
  def self.split(text)
    text ? text.split(/[,，]\s*/).uniq : []
  end

  def as_json(options = nil)
    super(only: :name)['customer_tag']
  end
end
