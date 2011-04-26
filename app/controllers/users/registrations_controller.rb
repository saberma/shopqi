class Users::RegistrationsController < Devise::RegistrationsController
  protected
  def build_resource(hash=nil)    
    hash ||= params[resource_name] || {} 
    self.resource = resource_class.new_with_session(hash, session)
    self.resource.shop = Shop.new(hash[:shop_attributes])
  end
end
