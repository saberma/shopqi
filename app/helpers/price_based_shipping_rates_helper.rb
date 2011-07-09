module PriceBasedShippingRatesHelper
  def attr_for_display(obj)
     obj ? "display:none" : ""
  end
end
