# encoding: utf-8
class StorageValidator < ActiveModel::Validator #验证容量是否超过商店限制

  # 需要限制的地方:
  # 1. 图片上传
  # 2. 主题上传
  # 3. 附件上传
  def validate(record)
    record.errors[:base] << "商店容量已经用完，详情请进入[帐号]页面查看" unless record.shop.storage_idle?
  end

end
