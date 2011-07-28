class Users::RegistrationsController < Devise::RegistrationsController
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  def create
    build_resource

    if resource.save
      sign_in(resource_name, resource)
      render json: {}
    else
      render json: resource.errors.to_json
    end
  end

  def check_availability
    render text: ShopDomain.exists?(host: "#{params[:domain]}")
  end
end
