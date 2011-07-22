class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :operate , comment: "操作类型"
      t.string :content , comment: "操作内容"
      t.references :user, comment: "操作用户"
      t.string :class_name, comment: "操作对象"

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
