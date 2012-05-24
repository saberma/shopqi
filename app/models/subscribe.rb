class Subscribe < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user
  attr_accessible :kind, :address, :number, :user

  validates :address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, allow_nil: true,uniqueness: true

  def email_address
    address || user.email
  end
end
