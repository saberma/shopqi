# encoding: utf-8
class Shop < ActiveRecord::Base
  include OAuth2::Model::ClientOwner
  include OAuth2::Model::ResourceOwner
  has_many :users                 , dependent: :destroy
  has_many :domains               , dependent: :destroy                      , order: :id.asc, class_name: 'ShopDomain'
  has_many :products              , dependent: :destroy                      , order: :id.desc
  has_many :variants              , class_name: 'ProductVariant' #冗余shop_id
  has_many :link_lists            , dependent: :destroy                      , order: :id.asc
  has_many :pages                 , dependent: :destroy
  has_many :blogs                 , dependent: :destroy
  has_many :smart_collections     , dependent: :destroy
  has_many :custom_collections    , dependent: :destroy
  has_many :tags                  , dependent: :destroy
  has_many :orders                , dependent: :destroy                      , order: :id.desc
  has_many :customers             , dependent: :destroy                      , order: :id.asc
  has_many :customer_groups       , dependent: :destroy
  has_many :customer_tags         , dependent: :destroy
  has_many :carts                 , dependent: :destroy
  has_many :subscribes            , dependent: :destroy
  has_many :comments              , dependent: :destroy
  has_one  :theme                 , dependent: :destroy                      , class_name: 'ShopTheme'
  has_many :oauth2_consumer_tokens, dependent: :destroy                      , class_name: 'OAuth2::Model::ConsumerToken'

  has_many :types                 , dependent: :destroy                      , class_name: 'ShopProductType'
  has_many :vendors               , dependent: :destroy                      , class_name: 'ShopProductVendor'
  has_many :emails                , dependent: :destroy
  has_many :countries             , dependent: :destroy
  has_many :activities            , dependent: :destroy                      , order: 'created_at desc'
  has_many :payments              , dependent: :destroy
  has_many :tasks                 , dependent: :destroy                      , order: :id.asc, class_name: 'ShopTask'
  has_many :policies              , dependent: :destroy                     ,  order: :id.asc, class_name: 'ShopPolicy'
  has_many :consumptions          , dependent: :destroy

  accepts_nested_attributes_for :domains, :theme, :policies
  attr_readonly :orders_count
  validates_presence_of :name

  before_create :init_valid_date

  def self.at(domain) # 域名
    ShopDomain.from(domain).shop
  end

  def launch! # 启用商店
    self.update_attributes! guided: true, password_enabled: false
  end

  def primary_domain # 主域名
    domains.primary
  end

  def plan_type
    KeyValues::Plan::Type.find_by_code(self.plan)
  end

  protected
  def init_valid_date
    self.deadline = Date.today.next_day(30)
  end

  def available?
    !self.deadline.past?
  end

end

class ShopDomain < ActiveRecord::Base # 域名
  belongs_to :shop

  #域名须为3到20位数字和字母组成的，且唯一
  validates :subdomain, presence: true, length: 3..32        , format: {with:  /\A([a-z0-9])*\Z/ }, unless: "domain.blank?"
  validates :host     , presence: true, length: {maximum: 64}, uniqueness: {scope: :shop_id}

  before_validation do
    self.host ||= "#{self.subdomain}#{self.domain}"
  end

  before_update do # 设置主域名
    if primary and primary_changed?
      shop.domains.primary.update_attributes primary: false, force_domain: false
    end
  end

  before_destroy do
    shop.domains.myshopqi.update_attributes primary: true if primary # 删除的主域名
  end

  # @host admin.myshopqi.com
  def self.from(host)
    where(host: host).first
  end

  def self.myshopqi # shopqi官方提供的二级子域名
    where(domain: Setting.store_host).first
  end

  def self.primary # 主域名
    where(primary: true).first
  end

  def is_myshopqi? # 是否为shopqi官方提供的二级子域名
    self.domain == Setting.store_host
  end

  def url # http://admin.myshopqi.com
    store = "http://#{self.host}"
    store += ":#{Setting.domain.port}" unless Setting.domain.port == 80
    store
  end
end

class ShopProductType < ActiveRecord::Base #商品类型
  belongs_to :shop
end

class ShopProductVendor < ActiveRecord::Base #商品厂商
  belongs_to :shop
end

class ShopPolicy< ActiveRecord::Base #商店政策
  belongs_to :shop
end

class ShopTask < ActiveRecord::Base #新手指引任务
  belongs_to :shop
  scope :incomplete, where(completed: false)

  before_update do
    if is_launch? and completed and completed_changed? # 启用商店
      shop.launch!
    end
  end

  def is_launch?
    name == 'launch'
  end
end
