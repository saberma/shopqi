#encoding: utf-8
class CreateDoorkeeperTables < ActiveRecord::Migration # OAuth2 Provider 改为使用 Doorkeeper

  module OAuth2 # faux model，源代码已经删除此实体文件
    module Model

      class Client < ActiveRecord::Base
        set_table_name :oauth2_clients
        has_many :authorizations, :class_name => 'OAuth2::Model::Authorization'
      end

      class Authorization < ActiveRecord::Base
        set_table_name :oauth2_authorizations

        def self.create_access_token
          OAuth2.generate_id do |token|
            hash = OAuth2.hashify(token)
            count(:conditions => {:access_token_hash => hash}).zero?
          end
        end
      end

      class ConsumerToken < ActiveRecord::Base
        set_table_name :oauth2_consumer_tokens
      end

      class ConsumerClient < ActiveRecord::Base
        set_table_name :oauth2_consumer_clients
      end

    end
  end

  class Shop < ActiveRecord::Base
    has_many :oauth2_consumer_tokens, class_name: 'OAuth2::Model::ConsumerToken'
  end

  def up
    create_table :oauth_applications do |t|
      t.string :name,         :null => false
      t.string :uid,          :null => false, :limit => 64
      t.string :secret,       :null => false, :limit => 64
      t.string :redirect_uri, :null => false
      t.timestamps
    end

    add_index :oauth_applications, :uid, :unique => true

    create_table :oauth_access_grants do |t|
      t.integer  :resource_owner_id, :null => false
      t.integer  :application_id,    :null => false
      t.string   :token,             :null => false, :limit => 64
      t.integer  :expires_in,        :null => false
      t.string   :redirect_uri,      :null => false
      t.datetime :created_at,        :null => false
      t.datetime :revoked_at
      t.string   :scopes
    end

    add_index :oauth_access_grants, :token, :unique => true

    create_table :oauth_access_tokens do |t|
      t.integer  :resource_owner_id
      t.integer  :application_id,    :null => false
      t.string   :token,             :null => false, :limit => 64
      t.string   :refresh_token,     :limit => 64
      t.integer  :expires_in
      t.datetime :revoked_at
      t.datetime :created_at,        :null => false
      t.string   :scopes
    end

    add_index :oauth_access_tokens, :token, :unique => true
    add_index :oauth_access_tokens, :resource_owner_id
    add_index :oauth_access_tokens, :refresh_token, :unique => true

    application = Doorkeeper::Application.create! name: Theme.client_name, redirect_uri: Theme.client_redirect_uri
    Shop.all.each do |shop| # 授权时检查到有 access_token，就表示已经授权，同时会生成 access_grant
      application.access_tokens.create! resource_owner_id: shop.id, expires_in: Doorkeeper.configuration.access_token_expires_in
    end

    drop_table :oauth2_clients
    drop_table :oauth2_authorizations
    drop_table :oauth2_consumer_clients
    drop_table :oauth2_consumer_tokens
  end

  def down
    create_table :oauth2_clients do |t|
      t.string     :oauth2_client_owner_type
      t.integer    :oauth2_client_owner_id
      t.string     :name
      t.string     :client_id
      t.string     :client_secret_hash
      t.string     :redirect_uri
      t.timestamps
    end
    add_index :oauth2_clients, :client_id

    create_table :oauth2_authorizations do |t|
      t.string     :oauth2_resource_owner_type
      t.integer    :oauth2_resource_owner_id
      t.belongs_to :client
      t.string     :scope
      t.string     :code,               limit: 40
      t.string     :access_token_hash,  limit: 40
      t.string     :refresh_token_hash, limit: 40
      t.datetime   :expires_at
      t.timestamps
    end
    add_index :oauth2_authorizations, [:client_id, :code]
    add_index :oauth2_authorizations, [:access_token_hash]
    add_index :oauth2_authorizations, [:client_id, :access_token_hash]
    add_index :oauth2_authorizations, [:client_id, :refresh_token_hash]

    create_table :oauth2_consumer_clients do |t|
      t.string :name         , limit: 20, unique: true
      t.string :client_id    , limit: 40
      t.string :client_secret, limit: 40
      t.datetime :created_at
    end
    add_index :oauth2_consumer_clients, :name

    create_table :oauth2_consumer_tokens do |t|
      t.integer :shop_id
      t.string :client_id   , limit: 40
      t.string :access_token, limit: 40
      t.datetime :created_at
    end
    add_index :oauth2_consumer_tokens, [:shop_id, :client_id]

    client = OAuth2::Model::Client.create name: Theme.client_name, redirect_uri: Theme.client_redirect_uri
    OAuth2::Model::ConsumerClient.create name: Theme.client_name, client_id: client.client_id, client_secret: client.client_secret
    Shop.each do |shop|
      author = shop.oauth2_authorizations.build client: client
      author.access_token = OAuth2::Model::Authorization.create_access_token
      author.save
      shop.oauth2_consumer_tokens.create client_id: client.client_id, access_token: author.access_token
    end

    drop_table :oauth_access_tokens
    drop_table :oauth_access_grants
    drop_table :oauth_applications
  end
end
