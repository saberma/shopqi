# encoding: utf-8
class Shop < ActiveRecord::Base
  include OAuth2::Model::ClientOwner
  include OAuth2::Model::ResourceOwner
  has_many :users                 , dependent: :destroy
  has_many :domains               , dependent: :destroy                      , class_name: 'ShopDomain'
  has_many :products              , dependent: :destroy                      , order: :id.desc
  has_many :variants              , class_name: 'ProductVariant' #冗余shop_id
  has_many :link_lists            , dependent: :destroy
  has_many :pages                 , dependent: :destroy
  has_many :blogs                 , dependent: :destroy
  has_many :smart_collections     , dependent: :destroy
  has_many :custom_collections    , dependent: :destroy
  has_many :tags                  , dependent: :destroy
  has_many :orders                , dependent: :destroy
  has_many :customers             , dependent: :destroy
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
  has_many :activities            , dependent: :destroy                     , order: 'created_at desc'
  has_many :payments              , dependent: :destroy

  accepts_nested_attributes_for :domains
  attr_readonly :orders_count
  validates_presence_of :name

  before_create :init_valid_date

  def self.at(domain) # 域名
    ShopDomain.from(domain).shop
  end

  def primary_domain # 主域名
    domains.primary
  end

  protected
  def init_valid_date
    self.deadline = Date.today.next_day(10)
  end

  def available?
    !self.deadline.past?
  end

end

class ShopDomain < ActiveRecord::Base # 域名
  belongs_to :shop

  #域名须为3到20位数字和字母组成的，且唯一
  validates :subdomain, presence: true, length: 3..32        , format: {with:  /\A([a-z0-9])*\Z/ }
  validates :domain   , presence: true, length: {maximum: 32}
  validates :host     , presence: true, length: {maximum: 64}, uniqueness: true

  before_validation do
    self.host = "#{self.subdomain}#{self.domain}"
  end

  # @host admin.myshopqi.com
  def self.from(host)
    where(host: host).first
  end

  def self.primary # 暂时取第一个
    first
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
