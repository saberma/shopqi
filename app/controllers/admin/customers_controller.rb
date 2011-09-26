#encoding: utf-8
class CustomersController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:customers) do
    if params[:q] or params[:f]
      page_size = 25
      conditions = {}
      unless params[:f].blank?
        params[:f].each do |filter|
          condition, value = filter.split ':'
          value = case value.to_sym
            # 日期
            when :last_week then 1.week.ago
            when :last_month then 1.month.ago
            when :last_3_months then 3.month.ago
            when :last_year then 3.month.ago
            # 是否
            when :true then true
            when :false then false
            else
              value
          end
          case condition.to_sym
            when :last_order_date
              conditions[:orders_created_at_gt] = value
            when :last_abandoned_order_date
              conditions[:orders_status_eq] = :abandoned
              conditions[:orders_created_at_gt] = value
            when :accepts_marketing, :status
              conditions["#{condition}_eq"] = value
            else
              conditions[condition] = value
          end
        end
      end
      conditions.merge! name_contains: params[:q] unless params[:q].blank?
      shop.customers.limit(page_size).order(:id.desc).metasearch(conditions).all
    else
      shop.customers.order(:id.desc)
    end
  end
  expose(:customer_groups) { shop.customer_groups }
  expose(:customer)
  expose(:tags) { shop.customer_tags.previou_used }
  expose(:customers_json) do
    customers.to_json({
      methods: [ :default_address, :order, :total_spent ],
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:customer_groups_json) do
    customer_groups.to_json({
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:customer_json) do
    customer.to_json({
      include: {
        addresses: { methods: [:country_name,:province_name, :city_name, :district_name] },
        orders: { methods: [ :status_name, :financial_status_name, :fulfillment_status_name, :created_at] }
      },
      methods: [ :default_address, :order, :total_spent, :status_name, :tags_text ],
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:tags_json) { tags.to_json }
  expose(:page_sizes) { KeyValues::PageSize.hash }
  expose(:primary_filters) { KeyValues::Customer::PrimaryFilter.all }
  expose(:secondary_filters_integer) { KeyValues::Customer::SecondaryFilter::Integer.hash }
  expose(:secondary_filters_date) { KeyValues::Customer::SecondaryFilter::Date.hash }
  expose(:boolean) { KeyValues::Customer::Boolean.hash }
  expose(:status) { KeyValues::Customer::State.hash }

  def index
    render action: :blank_slate if customers.empty?
  end

  def new
    customer.addresses.build if customer.addresses.empty?
  end

  def create
    customer.password = Random.new.rand(100000..999999) #用于在后台新增用户时，为顾客增加一个随机密码
    if customer.save
      redirect_to customer_path(customer)
    else
      render action: :new
    end
  end

  def update
    customer.save
    render nothing: true
  end

  def show
  end

  def search
    render json: customers_json
  end
end
