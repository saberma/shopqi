# encoding: utf-8
class ActivityObserver < ActiveRecord::Observer
  cattr_accessor :current_user
  observe :blog, :article, :product, :custom_collection # 要确保记录关联shop

  def after_create(record)
    if record.class != Product
      record.shop.activities.log record, 'new', current_user
    end
  end

  def after_update(record)
    if record.class != Product
      record.shop.activities.log record, 'edit', current_user
    end
  end

  def after_destroy(record)
    record.shop.activities.log record, 'delete', current_user
  end

end
