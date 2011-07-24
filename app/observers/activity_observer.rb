# encoding: utf-8
class ActivityObserver < ActiveRecord::Observer
  cattr_accessor :current_user
  observe :blog,:article

  def after_create(record)
    Activity.log record,'new',current_user
  end

  def after_update(record)
    Activity.log record,'edit',current_user
  end

  def after_destroy(record)
    Activity.log record,'delete',current_user
  end
end
