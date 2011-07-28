class Payment < ActiveRecord::Base
  def payment_type
    KeyValues::PaymentType.find(self.payment_type_id)
  end
end
