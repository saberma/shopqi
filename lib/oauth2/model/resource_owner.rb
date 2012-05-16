module OAuth2
  module Model

    module ResourceOwner
      def self.included(klass)
        klass.has_many :oauth2_authorizations,
                       :class_name => 'OAuth2::Model::Authorization',
                       :as => :oauth2_resource_owner,
                       :dependent => :destroy
      end

      def grant_access!(client, options = {})
        authorization = oauth2_authorizations.find_by_client_id(client.id) ||
                        Model::Authorization.create(:owner => self, :client => client)

        if scopes = options[:scopes]
          scopes = authorization.scopes + scopes
          authorization.update_attribute(:scope, scopes.join(' '))
        end

        authorization
      end
    end

  end
end
