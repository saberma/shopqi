# encoding: utf-8
class Admin::ShopsController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: :me
  layout 'admin', only: :edit

  expose(:shop) { current_user.shop }
  expose(:currentcy_options) { KeyValues::Shop::Currency.options }

  def update
    if params[:shop][:order_number_format] && !params[:shop][:order_number_format].include?('{{number}}')
      params[:shop][:order_number_format] = '#{{number}}'
    end
    if shop.update_attributes(params[:shop])
      respond_to do |format|
        format.js   {render nothing: true}
        format.html {
          unless params[:shop][:policies_attributes]
            redirect_to general_preferences_path, notice: notice_msg
          else
            redirect_to payments_path, notice: notice_msg
          end
        }
      end
    else
      render action: 'edit',layout: 'admin'
    end
  end

end
