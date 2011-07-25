# encoding: utf-8
class ActivityObserver < ActiveRecord::Observer
  cattr_accessor :current_user
  observe :blog,:article,:product,:custom_collection

  def after_create(record)
    if record.class != Product
      Activity.log record,'new',current_user
    end
  end

  def after_update(record)
    if record.class != Product
      Activity.log record,'edit',current_user
    end
  end

  def after_destroy(record)
    Activity.log record,'delete',current_user
  end

end
