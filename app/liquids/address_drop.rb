class AddressDrop < Liquid::Drop

  def initialize(address)
    @address = address
  end

  delegate :name,:company,:address1,:address2, :zip, :phone, to:  :@address

  [:province,:city,:district].each do |k|
    define_method k do
      District.get @address.send(k)
    end
  end

  def country
    Carmen.country_name(@address.country_code)
  end

end
