#encoding: utf-8
class CreateOauth2Provider < ActiveRecord::Migration
  def self.up
    create_table :oauth2_clients, force: true do |t|
      t.string     :oauth2_client_owner_type
      t.integer    :oauth2_client_owner_id
      t.string     :name
      t.string     :client_id
      t.string     :client_secret_hash
      t.string     :redirect_uri
      t.timestamps
    end
    add_index :oauth2_clients, :client_id

    create_table :oauth2_authorizations, force: true do |t|
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

    create_table :oauth2_consumers, force: true do |t| # 非provider
      t.integer :shop_id    , comment: '所属商店'
      t.string :client_id
      t.string :access_token, limit: 36
      t.datetime :created_at
    end
    add_index :oauth2_consumers, [:shop_id, :client_id]
  end

  def self.down
    drop_table :oauth2_clients
    drop_table :oauth2_authorizations
    drop_table :oauth2_consumer
  end
end
