#encoding: utf-8
#用于存储富文本的一些信息
class CreateKindeditors < ActiveRecord::Migration
  def self.up
    create_table :kindeditors do |t|
      t.references :shop             , comment: "所属商店"                  , null: false
      t.string :kindeditor_image_uid
      t.timestamps
    end
  end

  def self.down
    drop_table :kindeditors
  end
end
