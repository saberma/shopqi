#encoding: utf-8
class CreateApiClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
      t.references :shop              , comment: '关联商店'

      t.string     :api_key           , limit: 32, comment: '授权api_key'
      t.string     :password          , limit: 32, comment: '授权密钥'
      t.string     :shared_secret     , limit: 32, comment: '共享密钥'
      t.string     :title             , limit: 36, comment: '标题'

      t.timestamps
    end
  end
end
