class LookupController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }

  expose(:results) do
    if params[:q].blank?
      nil
    else
      ThinkingSphinx.search params[:q], classes: [Product, Article, Page], with: { shop_id: shop.id }
    end
  end

  def query
  end

end
