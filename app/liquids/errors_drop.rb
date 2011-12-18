#encoding: utf-8
# 表单的错误信息
class ErrorsDrop < Liquid::Drop

  def initialize(errors)
    @messages = {}
    clazz = errors.instance_variable_get('@base').class
    errors.messages.each_pair do |attribute, error| # field转化为中文
      field = clazz.human_attribute_name attribute
      @messages[field] = error
    end
  end

  def each(&block) # 对象支持直接迭代
    @messages.keys.each(&block)
  end

  def messages
    @messages
  end

end
