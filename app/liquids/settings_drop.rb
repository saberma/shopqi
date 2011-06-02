class SettingsDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(name) #相当于method_missing
    value = @shop.theme.settings.where(name: name).first.try(:value)
    value = if value == 't'
              true
            elsif value == 'f'
              false
            else
              value
            end
    value
  end

end
