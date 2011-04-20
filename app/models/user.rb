# encoding: utf-8
class User < ActiveRecord::Base
  include SentientUser
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :shop_name,:shop_permanent_domain
  attr_accessible :email, :password, :password_confirmation, :remember_me,:shop_name,:shop_permanent_domain
  belongs_to :shop
  validates_presence_of :shop_name
  validates_presence_of :shop_permanent_domain
  validates_format_of :shop_permanent_domain, :with => /\A([a-z0-9])*\Z/
  validates_length_of :shop_permanent_domain, :within => 3..20
  validates_each :shop_permanent_domain do |record,field,value|
    if Shop.where(:permanent_domain =>value).first
      record.errors.add field, "已经存在"
    end
  end

  after_create :init_shop

  def init_shop
    # sentient_user
    if User.current
      self.shop = User.current.shop
    else
      self.shop = Shop.new(:name => shop_name,:permanent_domain => shop_permanent_domain)
    end
    save
  end
end
