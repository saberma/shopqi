class Payment < ActiveRecord::Base
  belongs_to :shop
  validates_presence_of :partner,:account,:key, if: Proc.new{|p| p.payment_type_id?}
  validates_presence_of :name, if: Proc.new{|p| !p.payment_type_id?}
  default_scope order('created_at')
  def payment_type
    KeyValues::PaymentType.find(self.payment_type_id)
  end
end
