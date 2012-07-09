# encoding: utf-8
class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.integer  :application_id,    comment: '通过 API 创建时的应用 ID'
      t.references :shop    , comment: '所属商店'
      t.string :event       , comment: '事件'         , null: false, limit: 32
      t.string :callback_url, comment: '回调 URL 地址', null: false, limit: 255
      t.datetime :created_at, comment: '创建日期'     , null: false
    end
  end
end
