# encoding: utf-8
class SkuValidator < ActiveModel::Validator #用于验证sku数量超过商店限制后不能再新增商品和款式 issues#282

  def validate(record)
    shop = record.shop || record.product.try(:shop)
    if !shop.nil? && shop.plan_type.skus <= shop.variants.size
      record.errors[:base] << "超过商店限制"
    end
  end

end

