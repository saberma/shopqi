#encoding: utf-8
class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.references :shop   , comment: '所属商店', null: false
      t.string :load_preset, comment: '预设'    , null: false

      t.timestamps
    end

    create_table :theme_settings do |t|
      t.references :theme, comment: '所属主题', null: false
      t.string :name     , comment: '名称'    , null: false
      t.string :value    , comment: '值'      , null: false

      t.timestamps
    end

    add_index :themes  , :shop_id
    add_index :theme_settings, :theme_id
  end

  def self.down
    drop_table :theme_settings
    drop_table :themes
  end
end
