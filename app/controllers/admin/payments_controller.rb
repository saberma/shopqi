#coding: utf-8
class Admin::PaymentsController < Admin::AppController
  layout 'admin'
  prepend_before_filter :authenticate_user!
  expose(:shop){ current_user.shop }
  expose(:payments){ shop.payments }
  expose(:payment_alipay_json){ shop.payments.alipay.to_json(except: [:created_at, :updated_at], methods: [:service_name]) }
  expose(:payment)
  expose(:payment_json){ payment.to_json(except: [:created_at, :updated_at], methods: [:service_name]) }
  expose(:policy_types){ KeyValues::PolicyType.all }
  expose(:policies){ shop.policies }
  expose(:all_custom_types){ KeyValues::Payment::Custom.all.map{|c|[c.name,c.name]}}
  expose(:custom_payments){ shop.payments.where(payment_type_id: nil).all }
  expose(:selected_custom_types){ custom_payments.map{|c|[c.name,c.name]} }
  expose(:custom_types){ all_custom_types - selected_custom_types }
  expose(:service_types){ KeyValues::Payment::Alipay::Service.options }

  def index
    if shop.policies.empty?
      policy_types.each  do |type|
        shop.policies.build title: type.name
      end
    end
  end

  def create
    payment.save
    render json: payment_json
  end

  def update
    payment.save
    render json: payment_json
  end

  def destroy
    payment.destroy
    render json: nil
  end
end
