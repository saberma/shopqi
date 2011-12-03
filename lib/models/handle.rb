module Models # 实体扩展模块

  module Handle # 包含handle属性的实体可使用此扩展

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def handle!(handle) # 通过handle查找记录，找不到则抛出错误
        self.where(handle: handle).first || (raise ActiveRecord::RecordNotFound)
      end

      def published_handle!(handle) # 通过handle查找对外公开的记录，找不到则抛出错误
        self.where(published: true, handle: handle).first || (raise ActiveRecord::RecordNotFound)
      end

    end

  end

end
