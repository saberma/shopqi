# encoding: utf-8
class User < ActiveRecord::Base
  include SentientUser
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :shop
  #accepts_nested_attributes_for :shop

  after_create :init_store

  def init_store
      # sentient_user
      if User.current
        self.shop = User.current.shop
      else
        # store一定要与user关联后再保存，否则store关联的记录无法取到user.store
        shop.save
      end
      self.save
    end
end
