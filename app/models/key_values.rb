# encoding: utf-8
module KeyValues
  module SmartCollectionRule

    class Column < ActiveHash::Base
      self.data = [
        {:id => 1, :name => '商品名称', :code => 'title'},
        {:id => 2, :name => '商品类型', :code => 'type'},
        {:id => 3, :name => '商品厂商', :code => 'vendor'},
        {:id => 4, :name => '商品价格', :code => 'variant_price'},
        {:id => 5, :name => '比较价格', :code => 'variant_compare_at_price'},
        {:id => 6, :name => '库存现货', :code => 'variant_inventory'},
        {:id => 7, :name => '属性名称', :code => 'variant_title'}
      ]
    end

    class Relation < ActiveHash::Base
      self.data = [
        {:id => 1, :name => '等于', :code => 'equals'},
        {:id => 2, :name => '大于', :code => 'greater_than'},
        {:id => 3, :name => '小于', :code => 'less_than'},
        {:id => 4, :name => '以此开头', :code => 'starts_with'},
        {:id => 5, :name => '以此结束', :code => 'ends_with'},
        {:id => 6, :name => '包含', :code => 'contains'},
      ]
    end

  end
end
