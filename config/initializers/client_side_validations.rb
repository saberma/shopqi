# encoding: utf-8
# ClientSideValidations Initializer

#require 'client_side_validations/simple_form' if defined?(::SimpleForm)
#require 'client_side_validations/formtastic' if defined?(::Formtastic)

# Uncomment the following block if you want each input field to have the validation messages attached.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    if instance.respond_to?(:object_name) and instance.object_name =~ /^order/ # 无奈的特殊处理: 商店订单address页面的错误提示需要换行(必要时使用instance.method_name细化判断)
      %{<div class="field-with-errors"><span class="error-message">#{instance.error_message.first}</span><br/>#{html_tag}</div>}.html_safe
    else
      #将输入项的后面插入的field_with_errors div改为span，否则会破坏布局(比如[价格]输入项后面带'元'，'元'字会被移至下一行)
      %{<span class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></span>}.html_safe
    end
  else
    #%{<span class="field_with_errors">#{html_tag}</span>}.html_safe
    html_tag.html_safe
  end
end

