#encoding: utf-8
class CreateSmartCollectionRules < ActiveRecord::Migration
  def self.up
    create_table :smart_collection_rules do |t|
      t.integer :smart_collection_id, comment: '所属集合'
      t.string :column, comment: '列'
      t.string :relation, comment: '判断关系'
      t.string :condition, comment: '判断值'

      t.timestamps
    end
  end

  def self.down
    drop_table :smart_collection_rules
  end
end
