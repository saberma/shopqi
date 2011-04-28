# encoding: utf-8
module KeyValues

  class Base < ActiveHash::Base
    def self.options
      all.map {|t| [t.name, t.code]}
    end
  end

  # 是否发布
  class PublishState < KeyValues::Base
    self.data = [
      {:id => 1, :name => '显示', :code => 'true'},
      {:id => 2, :name => '隐藏', :code => 'false'},
    ]
  end

  module Link

    #链接类型
    class Type < KeyValues::Base
      self.data = [
        #{:id => 1, :name => '博客', :code => 'blog'},
        #{:id => 2, :name => '商店首页', :code => 'frontpage'},
        #{:id => 3, :name => '商品列表', :code => 'collection'},
        #{:id => 4, :name => '指定页面', :code => 'page'},
        #{:id => 5, :name => '指定商品', :code => 'product'},
        #{:id => 6, :name => '查询页面', :code => 'search'},
        {:id => 7, :name => '其他网址', :code => 'http'}
      ]
    end

  end

  module SmartCollectionRule

    #规则相关列
    class Column < KeyValues::Base
      self.data = [
        {:id => 1, :name => '商品名称', :code => 'title'},
        {:id => 2, :name => '商品类型', :code => 'type'},
        {:id => 3, :name => '商品厂商', :code => 'vendor'},
        #{:id => 4, :name => '商品价格', :code => 'variant_price'},
        #{:id => 5, :name => '比较价格', :code => 'variant_compare_at_price'},
        {:id => 4, :name => '商品价格', :code => 'price'},
        {:id => 5, :name => '比较价格', :code => 'market_price'},
        {:id => 6, :name => '库存现货', :code => 'variant_inventory'},
        {:id => 7, :name => '属性名称', :code => 'variant_title'}
      ]
    end

    #规则关系
    class Relation < KeyValues::Base
      self.data = [
        {:id => 1, :name => '等于', :code => 'equals'},
        {:id => 2, :name => '大于', :code => 'greater_than'},
        {:id => 3, :name => '小于', :code => 'less_than'},
        {:id => 4, :name => '以此开头', :code => 'starts_with'},
        {:id => 5, :name => '以此结束', :code => 'ends_with'},
        {:id => 6, :name => '包含', :code => 'contains'},
      ]
    end

    #排序
    class Order < KeyValues::Base
      self.data = [
        {:id => 1, :name => '按标题拼音升序: A-Z', :code => 'title.asc'},
        {:id => 2, :name => '按标题拼音降序: Z-A', :code => 'title.desc'},
        #{:id => 3, :name => '按销售量排序', :code => 'best-selling'},
        {:id => 4, :name => '按创建日期: 最近-最远', :code => 'created_at.desc'},
        {:id => 5, :name => '按创建日期: 最远-最近', :code => 'created_at.asc'},
        {:id => 6, :name => '按价格排序: 最高-最低', :code => 'price.desc'},
        {:id => 7, :name => '按价格排序: 最低-最高', :code => 'price.asc'},
        {:id => 8, :name => '手动排序', :code => 'manual'},
      ]

      #手动排序?
      def self.is_manual?(order)
        'manual' == order
      end
    end

  end

end
