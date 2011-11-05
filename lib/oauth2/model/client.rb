module OAuth2
  module Model

    class Client < ActiveRecord::Base
      set_table_name :oauth2_clients

      belongs_to :oauth2_client_owner, :polymorphic => true
      alias :owner  :oauth2_client_owner
      alias :owner= :oauth2_client_owner=

      has_many :authorizations, :class_name => 'OAuth2::Model::Authorization', :dependent => :destroy

      validates_uniqueness_of :client_id
      validates_presence_of   :name, :redirect_uri
      validate :check_format_of_redirect_uri

      attr_accessible :name, :redirect_uri

      before_create :generate_credentials

      after_create  :generate_consumer_client

      def self.create_client_id
        OAuth2.generate_id do |client_id|
          count(:conditions => {:client_id => client_id}).zero?
        end
      end

      attr_reader :client_secret

      def client_secret=(secret)
        @client_secret = secret
        self.client_secret_hash = BCrypt::Password.create(secret)
      end

      def valid_client_secret?(secret)
        BCrypt::Password.new(client_secret_hash) == secret
      end

    private

      def check_format_of_redirect_uri
        uri = URI.parse(redirect_uri)
        errors.add(:redirect_uri, 'must be an absolute URI') unless uri.absolute?
      rescue
        errors.add(:redirect_uri, 'must be a URI')
      end

      def generate_credentials
        self.client_id = self.class.create_client_id
        self.client_secret = OAuth2.random_string
      end

      def generate_consumer_client
        ConsumerClient.create name: self.name, client_id: self.client_id, client_secret: self.client_secret
      end

    end
  end
end

