# encoding: utf-8
class Shop < ActiveRecord::Base
  has_many :users             , dependent: :destroy
  has_many :products          , dependent: :destroy
  has_many :variants          , class_name: 'ProductVariant' #冗余shop_id
  has_many :link_lists        , dependent: :destroy
  has_many :pages             , dependent: :destroy
  has_many :blogs             , dependent: :destroy
  has_many :smart_collections , dependent: :destroy
  has_many :custom_collections, dependent: :destroy
  has_many :tags              , dependent: :destroy
  has_many :orders            , dependent: :destroy
  has_many :customers         , dependent: :destroy
  has_many :customer_groups   , dependent: :destroy
  has_many :carts             , dependent: :destroy
  has_one  :theme             , dependent: :destroy                      , class_name: 'ShopTheme'

  has_many :types             , dependent: :destroy                      , class_name: 'ShopProductType'
  has_many :vendors           , dependent: :destroy                      , class_name: 'ShopProductVendor'
  has_many :emails            , dependent: :destroy

  attr_readonly :orders_count

  #二级域名须为3到20位数字和字母组成的，且唯一
  validates :permanent_domain, presence: true, uniqueness: true, format: {with:  /\A([a-z0-9])*\Z/ }, length: 3..20
  validates_presence_of :name

  before_create :init_valid_date

  # 域名
  def self.at(domain)
    Shop.where(permanent_domain: domain).first
  end

  protected
  def init_valid_date
    self.deadline = Date.today.next_day(10)
  end

  def available?
    !self.deadline.past?
  end
end

#商品类型
class ShopProductType < ActiveRecord::Base
  belongs_to :shop
end

#商品厂商
class ShopProductVendor < ActiveRecord::Base
  belongs_to :shop
end
