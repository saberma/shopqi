class AddressDrop < Liquid::Drop

  def initialize(address)
    @address = address
  end

  [:name,:company,:country,:province,:city,:district,:address1,:address2,:zip,:phone].each do |k|
    define_method k do
      @address.send k
    end
  end

end
