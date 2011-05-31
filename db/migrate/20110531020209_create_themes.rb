#encoding: utf-8
class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.references :shop, comment: '商品应从属于商店', null: false
      t.string :load_preset, comment: '预设'

      t.timestamps
    end

    add_index :themes         , :shop_id
  end

  def self.down
    drop_table :themes
  end
end
