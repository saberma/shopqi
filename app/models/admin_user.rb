class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  protected
  def self.find_for_database_authentication(warden_conditions) # 删除request key host校验
    conditions = warden_conditions.dup
    host = conditions.delete(:host)
    where(conditions).first
  end
end
