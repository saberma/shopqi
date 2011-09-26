#encoding: utf-8
class CountriesController < AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:countries){ shop.countries }
  expose(:selected_countries){ countries.map{|c| [Carmen::country_name(c.code),c.code]}}
  expose(:country)

  def create
    country.tax_percentage = 0.0 unless params[:charge_federal_tax]
    if params[:shipping] == '1'
      country.weight_based_shipping_rates.build name: '普通快递'
    end
    country.save
    redirect_to countries_path, notice: notice_msg
  end

  def destroy
    country.destroy
  end

  def update
    country.save
  end

end
