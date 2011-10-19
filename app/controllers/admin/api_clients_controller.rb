class Admin::ApiClientsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:api_clients){ shop.api_clients }
  expose(:api_clients_json){ api_clients.to_json }

  def index
  end

  def create
    api_client = shop.api_clients.create
    p api_client
    render json: api_client.to_json
  end

  def destroy
    api_client = shop.api_clients.find(params[:id]).destroy
    render json: api_client
  end

end
