class Admin::ApplicationsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:applications)
  expose(:application)
  expose(:applications_json){ applications.to_json }

end
