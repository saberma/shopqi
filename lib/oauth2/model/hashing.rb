module OAuth2
  module Model

    module Hashing
      def hashes_attributes(*attributes)
        attributes.each do |attribute|
          define_method("#{attribute}=") do |value|
            instance_variable_set("@#{attribute}", value)
            __send__("#{attribute}_hash=", value && OAuth2.hashify(value))
          end
          attr_reader attribute
        end

        class_eval <<-RUBY
          def reload(*args)
            super
            #{ attributes.inspect }.each do |attribute|
              instance_variable_set('@' + attribute.to_s, nil)
            end
          end
        RUBY
      end
    end

  end
end

