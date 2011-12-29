module Models # 实体扩展模块

  module Handle # 包含handle属性的实体可使用此扩展

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    def self.handleize(input) # 中文转为拼音、去掉首尾空格、转小写、空格和小数点转为横杠、删除其他特殊字符
      Pinyin.t(input).gsub(/[^\w\-\s\.]/, '').strip.downcase.gsub(/\s+|\./, '-')
    end

    module ClassMethods

      def handle!(handle) # 通过handle查找记录，找不到则抛出错误
        self.where(handle: handle).first || (raise ActiveRecord::RecordNotFound)
      end

      def published_handle!(handle) # 通过handle查找对外公开的记录，找不到则抛出错误
        self.where(published: true, handle: handle).first || (raise ActiveRecord::RecordNotFound)
      end

    end

    module InstanceMethods

      # @collection ie: shop.products
      def make_valid(collection) # 确保handle唯一
        self.handle = self.title if self.handle.blank?
        unique_handle = Models::Handle.handleize(self.handle)
        number = 1
        condition = {}
        condition[:id.not_eq] = self.id unless self.new_record?
        while collection.exists?(condition.merge(handle: unique_handle))
          unique_handle = "#{unique_handle}-#{number}"
          number += 1
        end
        self.handle = unique_handle
      end

    end

  end

end
