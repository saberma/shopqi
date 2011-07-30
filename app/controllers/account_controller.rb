class AccountController < ApplicationController
  prepend_before_filter :authenticate_user!
  can_edit_on_the_spot
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:users){ current_user.shop.users}
  expose(:user)
  expose(:payment_types){ KeyValues::PaymentType.payments(shop)}
  expose(:payments){ shop.payments }

  def change_ownership
    if params[:user]
      current_user.admin = false
      u = User.find(params[:user][:id])
      u.admin = true
      u.save
      current_user.save
    end
    redirect_to account_index_path
  end

  def update_attribute_on_the_spot
    klass, field, id = params[:id].split('__')
    payment = payments.where(:payment_type_id => id).first
    attrs = {:payment_type_id => id, field => params[:value]}
    if payment
      payment.update_attributes(attrs)
    else
      payment = payments.create(attrs)
    end
    render :text => payment.send(field)
  end

  #用于用户升级账户
  def change
  end

end
