class SettingsDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(name) #相当于method_missing
    @shop.theme.settings.where(name: name).first.try(:value)
  end

end
