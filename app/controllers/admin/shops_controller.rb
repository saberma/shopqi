# encoding: utf-8
class ShopsController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: :me
  layout 'admin', only: :edit

  expose(:shop) { current_user.shop }

  def update
    if params[:shop][:order_number_format] && !params[:shop][:order_number_format].include?('{{number}}')
      params[:shop][:order_number_format] = '#{{number}}'
    end
    shop.update_attributes(params[:shop])
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
  end

  begin 'api'
    def me
      authorization = OAuth2::Provider.access_token(nil, [], request)
      result = if authorization.valid?
        authorization.owner.as_json(only: [:deadline, :created_at, :updated_at, :name])['shop']
      else
        {error: 'No soup for you!'}
      end
      render json: result.to_json
    end
  end

end
