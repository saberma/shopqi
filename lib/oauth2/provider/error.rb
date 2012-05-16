module OAuth2
  class Provider

    class Error
      def initialize(message = nil)
        @message = message
      end

      def redirect?
        false
      end

      def response_body
        message = 'Bad request' + (@message ? ": #{@message}" : '')
        JSON.unparse(ERROR => INVALID_REQUEST, ERROR_DESCRIPTION => message)
      end

      def response_headers
        Exchange::RESPONSE_HEADERS
      end

      def response_status
        400
      end
    end

  end
end

