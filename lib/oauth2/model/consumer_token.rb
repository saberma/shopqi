module OAuth2
  module Model
    
    class ConsumerToken < ActiveRecord::Base
      set_table_name :oauth2_consumer_tokens
      belongs_to :shop
      validates_presence_of   :client_id, :shop_id, :access_token
    end

  end
end

