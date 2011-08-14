# encoding: utf-8
class DistrictController < Shopqi::AppController
  layout nil

  def list
    @result = District.list(params[:id])
    render :text => @result
  end
end
