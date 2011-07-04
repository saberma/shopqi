class CountriesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:countries){ shop.countries }
  expose(:selected_countries){ countries.map{|c| [Carmen::country_name(c.code),c.code]}}
  expose(:country)

  def create
    country.tax_percentage = 0.0 unless params[:charge_federal_tax]
    country.save
    redirect_to countries_path, notice: notice_msg
  end

end
