# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_many :orders
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress', order: 'id asc'
  has_and_belongs_to_many :tags, class_name: 'CustomerTag'

  accepts_nested_attributes_for :addresses


  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable
         #, :validatable # 校验要限制在shop范围下，因此不能使用devise自带校验 issue#199

  attr_accessible :id, :name, :email, :orders_count, :note, :accepts_marketing, :tags_text, :addresses_attributes, :password, :password_confirmation
  before_create :ensure_authentication_token # 生成login token，只使用一次
  validates_presence_of :name, :email
  validates_presence_of :password, if: :password_required?
  validates :email, uniqueness: {scope: :shop_id}, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }, allow_blank: true
  validates :password, confirmation: true, length: 6..20, allow_blank: true, if: :password_required?

  validates :name, length: 2..10, allow_blank: true

  # 标签
  attr_accessor :tags_text

  default_value_for :status, 'enabled'
  default_value_for :accepts_marketing, true

  def tags_text
    @tags_text ||= self.tags.map(&:name).join(', ')
  end

  def available_orders # 有效订单
    self.orders.where(financial_status: [:paid, :pending, :authorized])
  end

  # 默认地址
  def default_address
    address =  addresses.where(default_address: true).first ||  addresses.first || addresses.build # 商店顾客未下订单直接注册时没有地址
    json =  address.as_json(methods: [:province_name, :city_name, :district_name])
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
    attrs = { name: a.name, company: a.company, province: a.province, city: a.city,
              district: a.district, address1: a.address1, address2: a.address2, zip: a.zip, phone: a.phone }
    unless self.addresses.exists?(attrs)
      self.addresses.create attrs
    end
  end

  def after_token_authentication # 登录后取消token
    self.authentication_token = nil
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

  protected
  def self.find_for_database_authentication(warden_conditions) # http://j.mp/ogzr2M 重载devise方法，校验域名
    conditions = warden_conditions.dup
    host = conditions.delete(:host)
    shop_domain = ShopDomain.at(host)
    where(conditions).where(shop_id: shop_domain.shop_id).first
  end

  def password_required? # copy from devise
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer
  include ActionView::Helpers::FormOptionsHelper

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

  def province_option_tags
    arr = [["--省份--",""]]
    options_for_select (arr +  District.list),self.province
  end

  def city_option_tags
    arr = [["--城市--",""]]
    options_for_select arr + District.list(self.province),self.city
  end

  def district_option_tags
    arr = [["--地区--",""]]
    options_for_select arr + District.list(self.city),self.district
  end

  def detail_address
    "#{province_name}#{city_name}#{district_name}#{address1}".gsub(/市县/,'市').gsub(/市辖区/,'')
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
