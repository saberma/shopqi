#encoding: utf-8
class Admin::OrdersController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: :alipay_refund_notify
  skip_before_filter :check_permission     , only: :alipay_refund_notify
  skip_before_filter :force_domain         , only: :alipay_refund_notify
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)
  expose(:customer) { order.customer }
  expose(:order_json) do
    order.to_json({
      methods: [ :gateway, :status_name, :financial_status_name, :fulfillment_status_name, :shipping_rate_price, :other_orders ],
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
    render action: :blank_slate and return if shop.orders.empty?
    @limit = 50
    page = params[:page] || 1
    orders = if params[:search]
      @limit = params[:search].delete(:limit) || @limit
      params[:search][:financial_status_ne] = :abandoned if params[:search][:financial_status_eq].blank?
      params[:search][:status_eq] = :open if params[:search][:status_eq].blank?
      shop.orders.metasearch(params[:search])
    else
      shop.orders.metasearch(status_eq: :open, financial_status_ne: :abandoned)
    end
    orders = orders.page(page).per(@limit)
    @pagination = {total_count: orders.total_count, page: page.to_i, limit: @limit, results: orders.as_json(
      include: {
        customer: {only: [:id, :name]},
        line_items: {only: [:name, :quantity]},
        shipping_address: {only: [:name], methods: [:info]}
      },
      methods: [ :status_name, :financial_status_name, :fulfillment_status_name, :shipping_name ],
      except: [ :updated_at ]
    )}.to_json
    respond_to do |format|
      format.html
      format.js { render json: @pagination }
    end
  end

  def show
    if order.cancelled? and transaction = order.transactions.pending_refund.first
      payment = order.payment
      data = [{
        'trade_no' => order.trade_no,
        'amount' => transaction.amount,
        'reason' => '协商退款'
      }]
      @refund_apply_url = Gateway::Alipay::Refund.apply_url(payment.account, payment.key, payment.email, 'batch_no' => transaction.batch_no, 'data' => data, 'notify_url' => "#{request.protocol}#{shop.domains.myshopqi.host}#{alipay_refund_notify_order_path(order)}")
    end
  end

  # 批量修改
  def set
    operation = params[:operation].to_sym
    ids = params[:orders]
    if [:open, :close].include?(operation)
      value = (operation == :close) ? :closed : :open
      Order.transaction do
        shop.orders.find(ids).each do |order|
          order.status = value
          order.save
        end
      end
    else #支付授权
    end
    render nothing: true
  end

  def update
    render text: order.save
  end

  def close
    order.status = :closed
    order.save
    redirect_to orders_path
  end

  def open
    order.status = :open
    order.save
    redirect_to order_path(order)
  end

  def cancel
    amount = params[:refund] ? order.total_price : 0
    order.cancel!(email: params[:email], amount: amount)
    path = params[:refund] ? order_path(order) : orders_path # 需要退款直接返回订单详情
    redirect_to path
  end

  def destroy
    order.destroy
    redirect_to orders_path
  end

  begin 'from pay gateway'

    begin 'alipay'

      def alipay_refund_notify # 退款通知
        text = 'fail'
        shop = ShopDomain.at(request.host).shop
        if alipay = shop.payments.alipay
          notification = Gateway::Alipay::Refund::Notification.new(request.raw_post, alipay.key, alipay.account)
          notification.data.each do |item|
            order = shop.orders.find_by_trade_no(item.trade_no)
            if order and transaction = order.transactions.pending_refund.where(batch_no: notification.batch_no).first
              transaction.status = (item.result.downcase == 'success') ? 'success' : 'failure'
              transaction.save
            end
          end
        end
        render text: 'success'
      end

    end

  end
end
