#encoding: utf-8
class Shop::PasswordsController  < Shop::AppController
  skip_before_filter :must_has_theme
  expose(:shop) { Shop.at(request.host) }

  # new action is not need, it's contained in login page, show by js click.

  # POST /resource/password
  def create
    @customer = Customer.send_reset_password_instructions(email: params[:email])

    if successfully_sent?(@customer)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(:customer))
    else
      flash[:notice] = @customer.errors.full_messages
      redirect_to '/account/login#recover'
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    unless @customer # from update action
      @customer = shop.customers.build
      @customer.reset_password_token = params[:reset_password_token]
    end
    path = theme.template_path('customers/reset_password')
    path = Rails.root.join 'app/views/shop/templates/customers/reset_password.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_reset_password', 'customer' => CustomerDrop.new(@customer))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  # PUT /resource/password
  def update
    @customer = Customer.reset_password_by_token(params[:customer])

    if @customer.errors.empty?
      flash_message = @customer.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message)
      sign_in(:customer, @customer)
      respond_with @customer, location: after_sign_in_path_for(@customer)
    else
      edit
    end
  end

  protected

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_session_path(resource_name)
    end

end
