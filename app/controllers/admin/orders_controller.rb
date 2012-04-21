#encoding: utf-8
class Admin::OrdersController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:orders) do
    page_size = 100
    if params[:search]
      page_size = params[:search].delete(:limit) || page_size
      params[:search][:financial_status_ne] = :abandoned if params[:search][:financial_status_eq].blank?
      params[:search][:status_eq] = :open if params[:search][:status_eq].blank?
      shop.orders.limit(page_size).metasearch(params[:search]).all
    else
      shop.orders.limit(page_size).metasearch(status_eq: :open, financial_status_ne: :abandoned).all
    end
  end
  expose(:order)
  expose(:orders_json) do
    orders.to_json({
      include: {
        customer: {only: [:id, :name]},
        line_items: {only: [:name, :quantity]}
      },
      methods: [ :status_name, :financial_status_name, :fulfillment_status_name, :shipping_name ],
      except: [ :updated_at ]
    })
  end
  expose(:customer) { order.customer }
  expose(:order_json) do
    order.to_json({
      methods: [ :gateway, :status_name, :financial_status_name, :fulfillment_status_name, :shipping_rate_price ],
      include: {
        line_items: { methods: [:total_price, :fulfillment_created_at, :product_deleted] },
        transactions: {},
        histories: {},
        discount: { only: [:code, :amount] }
      },
      except: [ :updated_at ]
    })
  end
  expose(:status) { KeyValues::Order::Status.hash }
  expose(:financial_status) { KeyValues::Order::FinancialStatus.hash }
  expose(:fulfillment_status) { KeyValues::Order::FulfillmentStatus.hash }
  expose(:cancel_reasons) { KeyValues::Order::CancelReason.hash }
  expose(:tracking_companies) { KeyValues::Order::TrackingCompany.hash }
  expose(:latest_tracking_company) { shop.redis order.latest_tracking_company_key }
  expose(:latest_tracking_number) { shop.redis order.latest_tracking_number_key }
  expose(:page_sizes) { KeyValues::PageSize.hash }

  def index
    render action: :blank_slate if shop.orders.empty?
  end

  # 批量修改
  def set
    operation = params[:operation].to_sym
    ids = params[:orders]
    if [:open, :close].include?(operation)
      value = (operation == :close) ? :closed : :open
      orders.find(ids).each do |order|
        order.update_attribute :status, value
      end
    else #支付授权
    end
    render nothing: true
  end

  def update
    render text: order.save
  end

  def close
    order.update_attribute :status, :closed
    redirect_to orders_path
  end

  def open
    order.update_attribute :status, :open
    redirect_to order_path(order)
  end

  def cancel
    order.update_attribute :status, :cancelled
    order.send_email('order_cancelled') if params[:email]
    redirect_to orders_path
  end

  def destroy
    order.destroy
    redirect_to orders_path
  end
end
