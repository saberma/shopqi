class Users::RegistrationsController < Devise::RegistrationsController
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  protected
  def build_resource(hash=nil)    
    hash ||= params[resource_name] || {} 
    self.resource = resource_class.new_with_session(hash, session)
    self.resource.shop = Shop.new(hash[:shop_attributes])
  end
end
