#encoding: utf-8
#用来创建邮件信息模板
class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.references :shop
      t.string :title         ,comment: "邮件模板标题"      , null: false
      t.text :body            ,comment: "邮件内容liquid模板", null: false
      t.boolean :include_html ,comment: "是否使用html模板"  
      t.text :body_html       ,comment: "html模板内容"     

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
