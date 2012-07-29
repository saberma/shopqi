#encoding: utf-8
class Shop::RegistrationsController < Shop::AppController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  skip_before_filter :must_has_theme
  include Devise::Controllers::InternalHelpers
  include Shop::OrderHelper
  #layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }


  # GET /resource/sign_up
  def new
    resource = build_resource({})
    path = Rails.root.join 'app/views/shop/templates/customers/registrations.liquid'
    assign = template_assign('template' => 'customers')
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  # POST /resource
  def create
    build_resource
    resource.shop = shop

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        if checkout_url # 跳转到结算页面
          token = checkout_url.gsub(/.+\//,'')
          if cart = Cart.find_by_token(token)
           cart.customer = resource
           cart.save!
          end
          redirect_to checkout_url and return
        else
          respond_with resource, location: after_sign_in_path_for(resource_name, resource)
        end
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      path = Rails.root.join 'app/views/shop/templates/customers/registrations.liquid'
      assign = template_assign('template' => 'customers', 'customer' => CustomerDrop.new(resource))
      liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
      assign.merge!('content_for_layout' => liquid_view)
      html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
      render text: html
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new_with_session(hash, session)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # Returns the inactive reason translated.
  def inactive_reason(resource)
    reason = resource.inactive_message.to_s
    I18n.t("devise.registrations.reasons.#{reason}", :default => reason)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    if defined?(super)
      ActiveSupport::Deprecation.warn "Defining after_update_path_for in ApplicationController " <<
      "is deprecated. Please add a RegistrationsController to your application and define it there."
      super
    else
      after_sign_in_path_for(resource)
    end
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", true)
    self.resource = send(:"current_#{resource_name}")
  end
end
