# encoding: utf-8
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:name, :shop_attributes,:phone, :bio,  :receive_announcements

  belongs_to :shop
  has_many :articles, dependent: :destroy
  accepts_nested_attributes_for :shop

  def is_admin?
    admin
  end

  after_create do
    Subscribe.create shop: shop, user: self
  end

end

Blog
