#encoding: utf-8
class Shop::PasswordsController  < Shop::AppController
  prepend_before_filter :require_no_authentication
  skip_before_filter :must_has_theme
  expose(:shop) { Shop.at(request.host) }

  # GET /resource/password/new
  def new
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(email: params[:email])

    if successful_and_sane?(resource)
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      #respond_with_navigational(resource){ render_with_scope :new }
      flash[:notice] = resource.errors.full_messages
      redirect_to '/account/login#recover'
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    path = theme.template_path('customers/reset_password')
    path = Rails.root.join 'app/views/shop/templates/customers/reset_password.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_reset_password', 'customer' => CustomerDrop.new(resource))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      path = theme.template_path('customers/reset_password')
      path = Rails.root.join 'app/views/shop/templates/customers/reset_password.liquid' unless File.exist?(path)
      assign = template_assign('template' => 'customers_reset_password', 'customer' => CustomerDrop.new(resource))
      liquid_view = Liquid::Template.parse(File.read(path)).render(assign.merge!('reset_password_token' => resource.reset_password_token ))
      assign.merge!('content_for_layout' => liquid_view)
      html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
      render text: html
    end
  end

  protected

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end

end
