class Users::RegistrationsController < Devise::RegistrationsController
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  #def create
  #  super
  #  ap resource.errors
  #end
end
