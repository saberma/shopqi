#encoding: utf-8
#用来创建邮件信息模板
class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.references :shop
      t.string :title         ,comment: "邮件模板标题"      , null: false
      t.string :mail_type     ,comment: "邮件类型"          , null: false
      t.text :body            ,comment: "邮件内容liquid模板", null: false
      t.boolean :include_html ,comment: "是否使用html模板"  , default: false
      t.text :body_html       ,comment: "html模板内容"

      t.timestamps
    end

    #预定信息
    create_table :subscribes do |t|
      t.references :shop
      t.references :user
      t.string :kind,  comment: "预定信息类型：如用户下单时的提醒"
      t.string :address, comment: "预定信息的邮件地址"
      t.string :number,  comment: "预定号码"

      t.timestamps
    end

  end

  def self.down
    drop_table :subscribes
    drop_table :emails
  end
end
