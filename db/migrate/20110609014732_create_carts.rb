#encoding: utf-8
#购物车
class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts, id: false do |t|
      t.references :shop  , comment: "所属商店"             , null: false
      t.string :uuid      , comment: '主键，防止id顺序访问' , null: false, limit: 32, primary_key: true
      t.string :session_id, comment: '浏览器session'        , null: false, limit: 32
      t.string :cart_hash , comment: '(variant_id|quantity)', null: false
      t.timestamps
    end

    add_index :carts, :shop_id
    add_index :carts, :uuid
  end

  def self.down
    drop_table :carts
  end
end
