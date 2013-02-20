# encoding: utf-8
class Shop < ActiveRecord::Base
  has_many :api_clients           , dependent: :destroy                      , order: 'id asc'
  has_many :access_grants         , dependent: :destroy                      , class_name: 'Doorkeeper::AccessGrant', foreign_key: 'resource_owner_id'
  has_many :access_tokens         , dependent: :destroy                      , class_name: 'Doorkeeper::AccessToken', foreign_key: 'resource_owner_id'
  has_many :users                 , dependent: :destroy                      , order: 'id asc'
  has_many :domains               , dependent: :destroy                      , order: 'id asc', class_name: 'ShopDomain'
  has_many :products              , dependent: :destroy                      , order: 'id desc'
  has_many :variants              , class_name: 'ProductVariant' #冗余shop_id
  has_many :link_lists            , dependent: :destroy                      , order: 'id asc'
  has_many :discounts             , dependent: :destroy                      , order: 'id asc', extend: Discount::Extension
  has_many :pages                 , dependent: :destroy                      , order: 'id desc'
  has_many :blogs                 , dependent: :destroy                      , order: 'id desc'
  has_many :smart_collections     , dependent: :destroy                      , order: 'id desc'
  has_many :custom_collections    , dependent: :destroy                      , order: 'id desc'
  has_many :tags                  , dependent: :destroy
  has_many :orders                , dependent: :destroy                      , order: 'id desc'
  has_many :customers             , dependent: :destroy                      , order: 'id asc'
  has_many :customer_groups       , dependent: :destroy                      , order: 'id asc'
  has_many :customer_tags         , dependent: :destroy
  has_many :carts                 , dependent: :destroy
  has_many :subscribes            , dependent: :destroy
  has_many :comments              , dependent: :destroy
  has_many :themes                , dependent: :destroy                      , class_name: 'ShopTheme', extend: ShopTheme::Extension
  has_many :shippings             , dependent: :destroy                      , order: 'code desc',      extend: Shipping::Extension

  has_many :types                 , dependent: :destroy                      , class_name: 'ShopProductType'
  has_many :vendors               , dependent: :destroy                      , class_name: 'ShopProductVendor'
  has_many :emails                , dependent: :destroy
  has_many :webhooks              , dependent: :destroy                      , order: 'id asc'
  has_many :activities            , dependent: :destroy                      , order: 'created_at desc', extend: Activity::Extension
  has_many :payments              , dependent: :destroy                      , order: 'payment_type_id, created_at'
  has_many :tasks                 , dependent: :destroy                      , order: 'id asc', class_name: 'ShopTask'
  has_many :policies              , dependent: :destroy                      , order: 'id asc', class_name: 'ShopPolicy'
  has_many :consumptions          , dependent: :destroy
  has_many :kindeditors           , dependent: :destroy                      , order: :id.asc

  accepts_nested_attributes_for :domains, :themes, :policies
  attr_readonly :orders_count
  attr_accessible :name, :phone, :plan, :province, :city, :district, :zip_code, :address, :email, :password, :password_enabled, :password_message, :currency, :money_with_currency_format, :money_format, :money_with_currency_in_emails_format, :money_in_emails_format, :order_number_format, :signup_source, :guided, :access_enabled, :domains_attributes, :themes_attributes, :policies_attributes
  attr_protected :deadline
  validates_length_of :name, maximum: 16
  validates_presence_of :name, :email, :plan
  validates :email, email_format: true
  validates_length_of :address, maximum: 64

  before_create :init_valid_date, :init_currency

  after_create do
    FileUtils.mkdir_p self.path
  end

  before_update do
    self.set_currency_format if currency_changed? # 修改币种，则更新相应格式(如果用户同时修改格式，则会被覆盖)
  end

  def collections
    custom_collections.where(published: true) + smart_collections.where(published: true)
  end

  def collection(handle)
    custom_collections.where(handle: handle, published: true).first || smart_collections.where(handle: handle, published: true).first
  end

  def launch! # 启用商店
    self.update_attributes! guided: true, password_enabled: false
  end

  begin 'domain'

    def self.at(domain) # 域名
      ShopDomain.at(domain).shop
    end

    def primary_domain # 主域名
      domains.primary
    end

    def domain
      primary_domain.host
    end

    def shopqi_domain # 官方二级域名
      "#{domains.myshopqi.host}#{Setting.domain.port}"
    end

  end

  begin 'plan' # 商店帐号类型

    def plan_type
      KeyValues::Plan::Type.find_by_code(self.plan)
    end

    def plan_free?
      self.plan == 'free'
    end

    def storage # 已占用的容量(如要支持windows可修改为循环获取目录大小)
      smart_fetch(self.storage_cache_key, expires_in: 5.minutes) do
        `du -sm #{self.path} | awk '{print $1}'`.to_i # 以M为单位
      end
    end

    def available?
      self.deadline.nil? or !self.deadline.past?
    end

    def storage_idle? # 存在剩余空间
      (self.plan_type.storage - self.storage) > 0
    end

  end

  begin 'customer account' #用于顾客结账页面是否需要登录账号
    def customer_accounts_required?
      customer_accounts == 'required'
    end

    def customer_accounts_optional?
      customer_accounts == 'optional'
    end
  end

  begin 'Theme' # 主题相关

    def theme # 普通主题
      themes.where(role: 'main').first
    end

    def mobile_theme # 手机主题
      themes.where(role: 'mobile').first
    end

  end

  begin 'path'

    def path # 商店相关的文件(主题)存放路径 /data/shops/1
      Rails.root.join 'data', 'shops', test_dir, self.id.to_s
    end

    def public_path # 允许外部访问的商店相关文件(主题)存放路径 /public/s/files/1
      Rails.root.join 'public', 's', 'files', test_dir, self.id.to_s
    end

  end

  begin 'format money' # 传入金额，返回格式化后的金额

    def format_money_with_currency(money)
      self.money_with_currency_format.gsub('{{amount}}', money.to_s).gsub('{{amount}}', money.round.to_s)
    end

    def format_money(money)
      self.money_format.gsub('{{amount}}', money.to_s).gsub('{{amount}}', money.round.to_s)
    end

    def format_money_with_currency_in_emails(money)
      self.money_with_currency_in_emails_format.gsub('{{amount}}', money.to_s).gsub('{{amount}}', money.round.to_s)
    end

    def format_money_in_emails(money)
      self.money_in_emails_format.gsub('{{amount}}', money.to_s).gsub('{{amount}}', money.round.to_s)
    end

  end

  begin 'redis' # 缓存时使用的key

    def storage_cache_key
      "shop_storage_#{self.id}"
    end

    def redis(key, value = nil) # 存储到redis，统一在key前增加shop.id
      if value.nil?
        Resque.redis.get "#{self.id}_#{key}"
      else
        Resque.redis.set "#{self.id}_#{key}", value
      end
    end

  end

  begin 'api'

    def installed_apps
      self.access_tokens.select('distinct application_id').includes(:application).map(&:application).reject{|app| app.name == Theme.client_name }
    end

  end

  after_destroy do # 删除对应的目录
    FileUtils.rm_rf self.path
    FileUtils.rm_rf self.public_path
  end

  protected
  def init_valid_date
    self.deadline = Date.today.advance months: 1 unless self.plan_free?
  end

  def init_currency
    self.currency ||= 'CNY' # 初始化为人民币
    set_currency_format
  end

  def set_currency_format # 设置币种显示格式
    data = KeyValues::Shop::Currency.find_by_code(currency)
    self.money_with_currency_format           = data.html_unit
    self.money_format                         = data.html
    self.money_with_currency_in_emails_format = data.email_unit
    self.money_in_emails_format               = data.email
  end

end

class ShopDomain < ActiveRecord::Base # 域名
  belongs_to :shop
  attr_accessible :subdomain, :domain, :host, :primary, :force_domain, :record

  #域名须为3到20位数字和字母组成的，且唯一
  validates :subdomain, presence: true, length: 3..32        , format: {with:  /^([a-z0-9\-])*$/ }, unless: "domain.blank?"
  validates :host     , presence: true, length: {maximum: 64}, uniqueness: {scope: :shop_id}
  validates :record   , presence: true, length: {maximum: 32}

  before_validation do
    self.record = Setting.domain.record if self.record.blank?
    self.host ||= "#{self.subdomain}#{self.domain}"
  end

  before_create do
    self.verified = is_myshopqi? # 子域名则直接通过审核
    self # avoid ActiveRecord::RecordNotSaved
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
  def self.at(host)
    where(host: host, verified: true).first
  end

  def self.valid_exists?(host)
    !at(host).nil?
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

  def url # http://apple.myshopqi.com
    "http://#{self.host}"
  end
end

class ShopProductType < ActiveRecord::Base #商品类型
  belongs_to :shop
  attr_accessible :name
end

class ShopProductVendor < ActiveRecord::Base #商品厂商
  belongs_to :shop
  attr_accessible :name
end

class ShopPolicy< ActiveRecord::Base #商店政策
  belongs_to :shop
  attr_accessible :title, :body
end

class ShopTask < ActiveRecord::Base #新手指引任务
  belongs_to :shop
  attr_accessible :name, :completed
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

class CancelReason < ActiveRecord::Base
  attr_accessible :selection, :detailed
end
