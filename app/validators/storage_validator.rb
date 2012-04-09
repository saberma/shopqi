# encoding: utf-8
class StorageValidator < ActiveModel::Validator #验证容量是否超过商店限制

  # 需要限制的地方:
  # 1. 商品图片上传
  # 2. 富文本框的图片上传
  # 3. 主题上传、复制和安装(直接判断)
  # 4. 附件上传(直接判断)
  # 5. 主题设置中的图片上传(直接判断)
  def validate(record)
    record.errors[:base] << I18n.t('activerecord.errors.models.shop.attributes.storage.full') unless record.shop.nil? or record.shop.storage_idle?
  end

end
