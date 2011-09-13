class SettingsDrop < Liquid::Drop

  def initialize(theme)
    @theme = theme
  end

  def before_method(name) #相当于method_missing
    value = @theme.settings.where(name: name).first.try(:value)
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
