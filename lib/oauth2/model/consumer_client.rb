module OAuth2
  module Model
    
    class ConsumerClient < ActiveRecord::Base
      set_table_name :oauth2_consumer_clients
      validates_presence_of   :client_id, :client_secret
    end

  end
end

