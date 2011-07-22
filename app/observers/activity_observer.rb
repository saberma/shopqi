# encoding: utf-8
class ActivityObserver < ActiveRecord::Observer
  cattr_accessor :current_user
  observe :product
  def after_update(record)
    Activity.log
  end

  def after_create(record)
    p record.class
  end

  def after_destroy(record)
  end
end
