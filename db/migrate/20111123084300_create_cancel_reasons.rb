#encoding: utf-8
class CreateCancelReasons < ActiveRecord::Migration
  def change
    create_table :cancel_reasons do |t|
      t.string :selection          ,comment: '关闭商店原因选项'
      t.string :detailed           ,comment: '关闭商店原因具体内容'
      t.timestamps
    end
    add_column :shops, :access_enabled, :boolean, default: true  #此字段用于，判断商店是否关闭（删除）了，true为没删除，false为删除了
  end
end
