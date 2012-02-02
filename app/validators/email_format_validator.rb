# encoding: utf-8
class EmailFormatValidator < ActiveModel::EachValidator #用于邮件校验

  def validate_each(object, attribute, value)
    unless value =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
      object.errors[attribute] << (options[:message] || "格式不对")
    end
  end

end
