class Api::ShopsController < Api::AppController
  before_filter :access_dennied, except: [:index]

  private
  def parent
    nil
  end

  def collection
    Shop.at(request.host)
  end
end
