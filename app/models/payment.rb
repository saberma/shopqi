class Payment < ActiveRecord::Base
  validates_presence_of :partner,:account,:key
  def payment_type
    KeyValues::PaymentType.find(self.payment_type_id)
  end
end
