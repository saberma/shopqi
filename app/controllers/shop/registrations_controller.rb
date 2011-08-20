#encoding: utf-8
class Shop::RegistrationsController < Devise::RegistrationsController
  layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }

  protected
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
    self.resource.shop = shop
  end
end
