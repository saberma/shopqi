class ProductObserver < ActiveRecord::Observer

  def after_save(product)
    #保存新增的类型、厂商
    unless product.shop.types.exists?(name: product.product_type)
      product.shop.types.create name: product.product_type
    end

    unless product.shop.vendors.exists?(name: product.vendor)
      product.shop.vendors.create name: product.vendor
    end
  end

end
