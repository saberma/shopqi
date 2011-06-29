class Subscribe < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user

  def email_address
    address || user.email
  end
end
